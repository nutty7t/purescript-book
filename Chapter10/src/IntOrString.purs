module IntOrString where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (defaultOptions, genericDecode, genericEncode)

data IntOrString
  = IntOrString_Int Int
  | IntOrString_String String

derive instance genericIntOrString :: Generic IntOrString _

instance encodeIntOrString :: Encode IntOrString where
  encode x = genericEncode defaultOptions x

instance decodeIntOrString :: Decode IntOrString where
  decode x = genericDecode defaultOptions x

instance showIntOrString :: Show IntOrString where
  show x = genericShow x

