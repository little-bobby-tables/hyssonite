module Main where

  import Scraper.Interface (scrape)
  import Server (runServer)

  main :: IO ()
  main = do
    url <- getLine
    scraped <- scrape url
    putStrLn $ case scraped of
      Nothing -> "Nothing"
      Just s -> show s
