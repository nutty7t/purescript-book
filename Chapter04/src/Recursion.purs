module Recursion where

import Prelude

import Data.Array (filter, head, length, null, tail)
import Data.Maybe (fromMaybe)
import Data.Ord (abs)

-- | Exercise 1
even :: Int -> Boolean
even 0 = true
even 1 = false
even n = even $ abs n - 2

-- | Exercise 2
-- | I present to you, my horrendous first attempt...
-- | I'm just a beginner!
countEven :: Array Int -> Int
countEven arr = _countEven arr zero
  where
    _countEven :: Array Int -> Int -> Int
    _countEven arr acc =
      if null arr
        then acc
        else
          if even $ fromMaybe 1 $ head arr
            then _countEven (fromMaybe [] $ tail arr) acc + 1
            else _countEven (fromMaybe [] $ tail arr) acc

-- | Here is another attempt without an accumulator.
-- | It's still kind of ugly. 👹
countEven2 :: Array Int -> Int
countEven2 arr =
  if null arr
    then 0
    else
      if even $ fromMaybe 1 $ head arr
        then 1 + (countEven2 $ fromMaybe [] $ tail arr)
        else countEven2 $ fromMaybe [] $ tail arr

-- | This one is not even recursive, but it makes me feel better.
countEven3 :: Array Int -> Int
countEven3 arr = length $ filter even arr

-- | This final attempt removes the nested conditional expression by defining
-- | the Boolean to Int casting as an auxiliary function in the where clause.
-- | Unwrapping values from Maybe types seems so verbose. Also, what are the
-- | conventions for indenting the 'where' keyword?
countEven4 :: Array Int -> Int
countEven4 arr =
  if null arr
    then 0
    else (int $ even $ fromMaybe 1 $ head arr) +
         (countEven4 $ fromMaybe [] $ tail arr)
  where
    int :: Boolean -> Int
    int true = 1
    int false = 0
