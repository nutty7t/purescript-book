module Records where

import Prelude

type Address = { street :: String, city :: String }

type Person = { name :: String, address :: Address }

-- | Exercise 1
-- sameCity :: Person -> Person -> Boolean
sameCity :: forall a b c d. { address :: { city :: String | a } | b } -> { address :: { city :: String | c } | d } -> Boolean
sameCity { address: { city: x } } { address: { city: y } } = x == y

-- | Exercise 3
fromSingleton :: forall a. a -> Array a -> a
fromSingleton d [e] = e
fromSingleton d arr = d

