module Server where

  import Scraper (Scraped, BString, toString)
  import Scraper.Interface (scrape)

  import Control.Monad (join)
  import Control.Monad.IO.Class (liftIO)

  import Blaze.ByteString.Builder.Char.Utf8 (fromString)

  import Network.Wai (Application, Request, Response, queryString, responseBuilder)
  import Network.Wai.Handler.Warp (run)
  import Network.HTTP.Types (ok200, notFound404, badRequest400)
  import Network.HTTP.Types.Header (hContentType)

  serverPort = 3030

  runServer :: IO ()
  runServer = run serverPort app

  app :: Application
  app request respond = apiResponse request >>= respond

  apiResponse :: Request -> IO Response
  apiResponse request = do
    let query = queryString request :: [(BString, Maybe BString)]
        requestedUrl = join $ lookup "url" query :: Maybe BString
    case requestedUrl of
      Just url -> scrape (toString url) >>= return . respondWithScraped
      Nothing -> return respondWith400

  respondWith400 :: Response
  respondWith400 = responseBuilder badRequest400 [] ""

  respondWithScraped :: Maybe Scraped -> Response
  respondWithScraped url = responseBuilder ok200 [(hContentType, "text/plain")] $ fromString (show url)
