{-# LANGUAGE DeriveGeneric #-}

module Scraper where

  import qualified Data.ByteString as S
  import qualified Data.ByteString.Char8 as SC8

  import GHC.Generics
  import Data.Aeson

  bString :: String -> SC8.ByteString
  bString = SC8.pack

  toString :: SC8.ByteString -> String
  toString = SC8.unpack

  type BString = S.ByteString

  data Scraped = Scraped
    { imageUrl     :: String
    , thumbnailUrl :: String
    , artist       :: Maybe String
    , pageUrl      :: Maybe String }
    deriving (Generic, Show, Eq)

  instance ToJSON Scraped where
    toEncoding = genericToEncoding defaultOptions
