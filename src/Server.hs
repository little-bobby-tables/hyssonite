module Server where

  import Scraper (Scraped, BString, toString)
  import Scraper.Interface (scrape)

  import Control.Monad (join)

  import Data.Aeson (encode)

  import Network.Wai (Application, Request, Response, queryString, responseBuilder, responseLBS)
  import Network.Wai.Handler.Warp (run)
  import Network.HTTP.Types (ok200, badRequest400)
  import Network.HTTP.Types.Header (hContentType)

  serverPort = 3030

  runServer :: IO ()
  runServer = run serverPort app

  app :: Application
  app request respond = apiResponse request >>= respond

  apiResponse :: Request -> IO Response
  apiResponse request =
    let requestedUrl = join $ lookup "url" $ queryString request
    in case requestedUrl of
      Just url -> scrape (toString url) >>= return . respondWithScraped
      Nothing -> return respondWith400

  respondWith400 :: Response
  respondWith400 = responseBuilder badRequest400 [] ""

  respondWithScraped :: Maybe Scraped -> Response
  respondWithScraped scraped =
    let json = encode scraped
    in responseLBS ok200 [(hContentType, "application/json")] json
