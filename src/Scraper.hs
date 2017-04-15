module Scraper where

  data Scraped = Scraped { imageUrl     :: String
                         , thumbnailUrl :: String
                         , artist       :: Maybe String
                         , pageUrl      :: Maybe String } deriving (Show)
