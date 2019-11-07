module BinaryTree where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (defaultOptions, genericDecode, genericEncode)

data Tree a = Leaf a | Branch (Tree a) (Tree a)

derive instance genericTree :: Generic (Tree a) _

instance encodeTree :: Encode a => Encode (Tree a) where
  encode t = genericEncode defaultOptions t

instance decodeTree :: Decode a => Decode (Tree a) where
  decode t = genericDecode defaultOptions t

instance showTree :: Show a => Show (Tree a) where
  show t = genericShow t

