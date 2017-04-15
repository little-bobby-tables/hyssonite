module Main where

  import Scraper.Interface (scrape)

  main :: IO ()
  main = do
    url <- getLine
    scraped <- scrape url
    putStrLn $ case scraped of
      Nothing -> "Nothing"
      Just s -> show s
