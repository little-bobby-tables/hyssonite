{-# LANGUAGE FlexibleInstances, GeneralizedNewtypeDeriving #-}

module HTTPCassette (HTTPCassette, playCassette) where

  import Scraper (BString, bString)
  import Scraper.Internal.MonadHTTP

  import System.Directory (getCurrentDirectory, doesFileExist)
  import Data.Binary (Binary, get, put, encode, decode)

  import qualified Data.ByteString.Lazy as L

  import Control.Monad.Catch (MonadThrow)

  import Crypto.Hash.SHA1 (hash)
  import Hexdump (simpleHex)

  import Network.HTTP.Conduit (Request, createCookieJar, destroyCookieJar)
  import Network.HTTP.Client.Internal (Response(..), ResponseClose(..))
  import Network.HTTP.Types.Status (statusCode, statusMessage, mkStatus)
  import Network.HTTP.Types.Version (http11)

  instance MonadHTTP (HTTPCassette IO) where
     httpLResponse = play

  newtype HTTPCassette m a = HTTPCassette
    { playCassette :: m a }
    deriving (Functor, Applicative, Monad, MonadThrow)

  play :: Request -> HTTPCassette IO LResponse
  play request = HTTPCassette $ do
    fixture <- fixtureFile
    doesFileExist fixture >>= \t -> if t
      then replay fixture
      else runAndRecord request fixture
    where hashId = (filter (/= ' ')) . simpleHex . hash . bString . show
          fixtureDir = (++ "/test/fixtures") <$> getCurrentDirectory
          fixtureFile = (++ "/" ++ hashId request) <$> fixtureDir

  replay :: FilePath -> IO LResponse
  replay fixture = L.readFile fixture >>= return . decode

  runAndRecord :: Request -> FilePath -> IO LResponse
  runAndRecord request fixture = do
    response <- httpLResponse request
    L.writeFile fixture (encode response)
    return response

  instance Binary LResponse where
    put (Response status _ headers body cookies rcls) = do
      put $ statusCode status
      put $ statusMessage status
      put $ show headers
      put $ (body :: L.ByteString)
      put $ show (destroyCookieJar cookies)

    get = do
      status <- do
        code <- get
        message <- get
        return (mkStatus code message)
      headers <- read <$> get
      body <- get
      cookies <- createCookieJar . read <$> get
      return $ Response status http11 headers body cookies (ResponseClose (return ()))
