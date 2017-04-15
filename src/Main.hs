module Main where

import Scraper.Interface (scrape)

import Network.HTTP.Conduit
import qualified Data.ByteString.Lazy as L

main :: IO ()
main = do
  --response <- simpleHttp "http://example.com"

  --L.putStr response

  url <- getLine
  putStrLn $ case scrape url of
    Nothing -> "Nothing"
    Just s -> show s
