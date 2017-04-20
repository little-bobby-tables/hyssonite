module Scraper.Internal.DOM ( (<@)
                            , hasAttr
                            , hasClass
                            , firstText
                            , firstAttr) where

  import Scraper (BString)

  import Text.HTML.TagSoup (Tag, isTagOpen, isTagText, fromAttrib, fromTagText)

  import Data.ByteString (isInfixOf)

  infixr 5 <@
  (<@) :: (a -> Bool) -> [a] -> [a]
  f <@ xs = dropWhile (not . f) xs

  hasAttr :: BString -> BString -> Tag BString -> Bool
  hasAttr attr content tag
    | isTagOpen tag = content `isInfixOf` (fromAttrib attr tag)
    | otherwise     = False

  hasClass :: BString -> Tag BString -> Bool
  hasClass = hasAttr "class"

  firstText :: [Tag BString] -> BString
  firstText ts = fromTagText $ head $ isTagText <@ ts

  firstAttr :: BString -> [Tag BString] -> BString
  firstAttr attr ts = fromAttrib attr (head ts)
