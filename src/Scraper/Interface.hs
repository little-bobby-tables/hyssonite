module Scraper.Interface (scrape) where

    import Text.Regex.PCRE

    import Scraper
    import qualified Scraper.Deviantart as DA

    scrape :: String -> Maybe Scraped
    scrape url
      | url =~ "\\Ahttps?://.+\\.deviantart\\.com/.+"
        = Just $ DA.fromPost url
      | url =~ "\\Ahttps?://.+\\.deviantart\\.net/.+d.+"
        = Just $ DA.fromCDN url
      | url =~ "\\Ahttps?://.+\\.tumblr\\.com/(post|image)/.+"
        = Nothing
      | url =~ "\\Ahttps?://.*\\.(jpg|jpeg|png|gif|svg)"
        = Nothing
      | otherwise
        = Nothing
