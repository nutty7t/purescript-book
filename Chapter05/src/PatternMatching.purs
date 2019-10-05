module PatternMatching where

import Prelude

-- | Exercise 1
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- | Exercise 2
choose :: Int -> Int -> Int
choose 0 0 = 1
choose n 0 = 1
choose n k
  | n == k = 1
  | otherwise = add (choose (n - 1) (k - 1)) (choose (n - 1) k)

