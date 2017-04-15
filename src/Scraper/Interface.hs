module Scraper.Interface (scrape) where

    import Text.Regex.PCRE ((=~))

    import Scraper
    import Scraper.Internal (MonadHTTP, redirectedFrom, httpUrl)
    import qualified Scraper.Deviantart as DA

    scrape :: (MonadHTTP m) => String -> m (Maybe Scraped)
    scrape = scrapeUrl -- TODO: use httpUrl to validate the URL

    scrapeUrl :: (MonadHTTP m) => String -> m (Maybe Scraped)
    scrapeUrl url
      | url =~ "\\Ahttps?://.+\\.deviantart\\.com/.+"
        = DA.fromPost url
      | url =~ "\\Ahttps?://(www.)?fav\\.me/.+"
        = redirectedFrom url >>= DA.fromPost
      | url =~ "\\Ahttps?://.+\\.deviantart\\.net/.+d.+"
        = DA.fromCDN url
      | url =~ "\\Ahttps?://.+\\.tumblr\\.com/(post|image)/.+"
        = return Nothing
      | url =~ "\\Ahttps?://.*\\.(jpg|jpeg|png|gif|svg)"
        = return Nothing
      | otherwise
        = return Nothing
