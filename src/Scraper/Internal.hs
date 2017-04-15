{-# LANGUAGE OverloadedStrings #-}

module Scraper.Internal where

  import Network.HTTP.Conduit
  import Data.Conduit (($$+-))

  --import Data.Text.Encoding (encodeUtf8)

  --import qualified Data.ByteString.UTF8 as U8
  import qualified Data.ByteString.Lazy as L

  import Control.Monad.Trans.Resource (runResourceT)

  --fetch :: String -> L.ByteString
  fetch url = do
    request <- parseRequest url
    manager <- newManager tlsManagerSettings
    response <- httpLbs request manager
    --let body = responseBody response
    responseBody response
    --case body of
    ---  Just r -> return r
    --  Nothing ->
