module Scraper where

  import qualified Data.ByteString as S
  import qualified Data.ByteString.Char8 as SC8

  bString :: String -> SC8.ByteString
  bString = SC8.pack

  toString :: SC8.ByteString -> String
  toString = SC8.unpack

  type BString = S.ByteString

  data Scraped = Scraped { imageUrl     :: BString
                         , thumbnailUrl :: BString
                         , artist       :: Maybe BString
                         , pageUrl      :: Maybe BString } deriving (Show, Eq)
