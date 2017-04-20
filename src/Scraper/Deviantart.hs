module Scraper.Deviantart (fromPost, fromCDN) where

  import Scraper
  import Scraper.Internal

  import Text.Regex.PCRE ((=~))

  import Network.HTTP.Conduit (Cookie)

  import Text.HTML.TagSoup.Fast (parseTags)
  import Text.HTML.TagSoup (Tag(..), isTagOpenName, fromAttrib)

  import Data.List (find)

  fromPost :: (MonadHTTP m) => String -> m (Maybe Scraped)
  fromPost url = do
    (cookies, body) <- fetchPage url []
    let page = parseTags body
        pageLinks = filter (isTagOpenName "a") page
        downloadLink = find (hasClass "dev-page-download") pageLinks
    imageUrl <- case downloadLink of
      Just link -> followDownloadLink (fromAttrib "href" link) cookies
      Nothing -> return $ firstAttr "src" $ hasClass "dev-content-full" <@ page
    let thumbnailUrl = firstAttr "src" $ hasClass "dev-content-normal" <@ page
        artist = firstText $ hasClass "username" <@ hasClass "dev-title-container" <@ page
        pageUrl = firstAttr "content" $ (hasAttr "property" "og:url") <@ page
    return $ Just Scraped { imageUrl = imageUrl
                          , thumbnailUrl = thumbnailUrl
                          , artist = Just artist
                          , pageUrl = Just pageUrl }

  followDownloadLink :: (MonadHTTP m) => BString -> [Cookie] -> m BString
  followDownloadLink link cookies =
    bString <$> redirectedFromWithCookies (toString link) cookies

  fromCDN :: (MonadHTTP m) => String -> m (Maybe Scraped)
  fromCDN url = do
    let idMatch = url =~ ("-(.+)\\..+\\z" :: String) :: [[String]]
        favMeCode = case length idMatch of
                      1 -> Just (last . head $ idMatch)
    case favMeCode of
      Just code -> redirectedFrom ("http://fav.me/" ++ code) >>= fromPost
