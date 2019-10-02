module Folds where

import Prelude

import Data.Array (foldl)

-- | Exercise 1
conjunction :: Array Boolean -> Boolean
conjunction = foldl (&&) true

-- | Exercise 3
fib :: Int -> Int
fib 0 = 1
fib 1 = 1
fib n = fib' (n - 2) 1 1
  where
    fib' :: Int -> Int -> Int -> Int
    fib' 0 x y = x + y
    fib' a x y = fib' (a - 1) y (x + y)

-- | Exercise 4
reverse :: forall a. Array a -> Array a
reverse = foldl (\xs x -> [x] <> xs) []

