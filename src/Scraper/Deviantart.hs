module Scraper.Deviantart (fromPost, fromCDN) where

  import Scraper

  import Scraper.Internal

  fromPost :: String -> Scraped
  fromPost url =

    Scraped "H" "h" (Just "h") (Just "h")

  fromCDN :: String -> Scraped
  fromCDN url =
    Scraped "D" "d" (Just "d") (Just "d")
