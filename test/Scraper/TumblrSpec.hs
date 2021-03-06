module Scraper.TumblrSpec where

  import Test.Hspec
  import HTTPCassette

  import Scraper (Scraped(..))
  import Scraper.Interface

  main :: IO ()
  main = hspec spec

  spec :: Spec
  spec = do
    describe "tumblr scraping" $ do
      it "handles /post links" $ (playCassette . scrape)
        "https://iam-photography.tumblr.com/post/157409807702/crescent-over-the-flame" >>= \scraped ->
          scraped `shouldBe` Just Scraped
            { imageUrl = "https://68.media.tumblr.com/f68ccec85fba7442ab715691d4d07615/tumblr_oldh8iK0kd1ubet1po1_1280.jpg"
            , thumbnailUrl = "https://68.media.tumblr.com/f68ccec85fba7442ab715691d4d07615/tumblr_oldh8iK0kd1ubet1po1_500.jpg"
            , artist = Just "iam-photography"
            , pageUrl = Just "http://iam-photography.tumblr.com/post/157409807702/crescent-over-the-flame" }

      it "handles /post links without slugs" $ (playCassette . scrape)
        "https://regnumsaturni.tumblr.com/post/155685354066?something#something" >>= \scraped ->
          scraped `shouldBe` Just Scraped
            { imageUrl = "https://68.media.tumblr.com/f4258a9dd1a3ed4e7122a8f7a5563095/tumblr_ojl0jzV49W1s0jbtpo1_1280.jpg"
            , thumbnailUrl = "https://68.media.tumblr.com/f4258a9dd1a3ed4e7122a8f7a5563095/tumblr_ojl0jzV49W1s0jbtpo1_500.jpg"
            , artist = Just "regnumsaturni"
            , pageUrl = Just "http://regnumsaturni.tumblr.com/post/155685354066" }

      it "handles /image links" $ (playCassette . scrape)
        "http://euph0r14.tumblr.com/image/152986865194" >>= \scraped ->
          scraped `shouldBe` Just Scraped
            { imageUrl = "http://68.media.tumblr.com/e7184fec946ac5726c357a8358ed0205/tumblr_ogf02thEGV1qh41oao1_1280.jpg"
            , thumbnailUrl = "http://68.media.tumblr.com/e7184fec946ac5726c357a8358ed0205/tumblr_ogf02thEGV1qh41oao1_500.jpg"
            , artist = Just "euph0r14"
            , pageUrl = Just "http://euph0r14.tumblr.com/post/152986865194/landscape-ripples-by-daniel-photo" }
