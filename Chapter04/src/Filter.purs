module Filter where

import Prelude

import Data.Array (filter)

-- | Exercise 1
squareArray :: Array Number -> Array Number
squareArray arr = (\x -> x * x) <$> arr

-- | Exercise 2
filterPositive :: Array Number -> Array Number
filterPositive arr = filter (\x -> x >= 0.0) arr

-- | Exercise 3
infix 0 filter as <$?>
filterPositive2 :: Array Number -> Array Number
filterPositive2 arr = (\x -> x >= 0.0) <$?> arr

