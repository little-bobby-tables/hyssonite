module Scraper.Tumblr (fromPost) where

  import Scraper
  import Scraper.Internal

  import Text.Regex.PCRE ((=~))

  import Text.HTML.TagSoup.Fast (parseTags)
  import Text.HTML.TagSoup (Tag(..), isTagOpenName, fromAttrib)

  import Data.List (find)

  postRegex :: String
  postRegex = "\\A(https?://.+\\.tumblr\\.com)/(post|image)/(\\d+)"

  fromPost :: (MonadHTTP m) => String -> m (Maybe Scraped)
  fromPost url = do
    doc <- parseTags . snd <$> fetchPage apiUrl []
    let imageUrl = firstText $ hasAttr "max-width" "1280" <@ doc
        thumbnailUrl = firstText $ hasAttr "max-width" "500" <@ doc
        artist = firstAttr "name" $ isTagOpenName "tumblelog" <@ doc
        pageUrl = firstAttr "url-with-slug" $ isTagOpenName "post" <@ doc
    return $ Just Scraped { imageUrl = imageUrl
                          , thumbnailUrl = thumbnailUrl
                          , artist = Just artist
                          , pageUrl = Just pageUrl }
    where apiUrl = blog ++ "/api/read?id=" ++ postId
          (blog, postId) = (\m -> ((m !! 1), (m !! 3))) . head $ (url =~ postRegex :: [[String]])
