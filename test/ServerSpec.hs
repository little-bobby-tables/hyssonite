{-# LANGUAGE QuasiQuotes #-}

module ServerSpec where

  import Test.Hspec
  import Test.Hspec.Wai
  import Test.Hspec.Wai.JSON

  import Server (app)

  main :: IO ()
  main = hspec spec

  spec :: Spec
  spec = with (return app) $ do
    describe "GET /?url=" $ do
      context "(supported url)" $ do
        it "responds with JSON-encoded scraped data" $ do
          get "/?url=http://somewebsite.com/image.png"
            `shouldRespondWith`
              [json| { imageUrl: "http://somewebsite.com/image.png",
                       thumbnailUrl: "http://somewebsite.com/image.png",
                       artist: null,
                       pageUrl: null } |]
              { matchStatus = 200
              , matchHeaders = ["Content-Type" <:> "application/json"] }

      context "(unsupported or invalid url)" $ do
        it "responds with Not Found" $ do
          get "/?url=https://www.someobscurefanartsite.org/images/56"
            `shouldRespondWith` 404

    describe "GET /" $ do
      it "responds with Bad Request" $ do
        get "/" `shouldRespondWith` 400
