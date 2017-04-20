module Scraper.MainSpec where

  import Test.Hspec
  import HTTPCassette

  import Scraper (Scraped(..))
  import Scraper.Interface

  main :: IO ()
  main = hspec spec

  spec :: Spec
  spec = do
    describe "direct image urls" $ do
      it "returns direct image urls without following them" $ (playCassette . scrape)
        "https://example.com/some/path/image.png" >>= \scraped ->
          scraped `shouldBe` Just Scraped
            { imageUrl = "https://example.com/some/path/image.png"
            , thumbnailUrl = "https://example.com/some/path/image.png"
            , artist = Nothing
            , pageUrl = Nothing }
