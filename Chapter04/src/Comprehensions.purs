module Comprehensions where

import Prelude

import Control.MonadPlus (guard)
import Data.Array (filter, head, length, (..))
import Data.Maybe (fromMaybe)

factors :: Int -> Array (Array Int)
factors n = do
  i <- 1 .. n
  j <- i .. n
  guard $ i * j == n
  pure [i, j]

-- | Exercise 1
isPrime :: Int -> Boolean
isPrime n = n > 1 && (length $ factors n) == 1

-- | Exercise 2
product :: forall a. Array a -> Array a -> Array (Array a)
product a b = do
  i <- a
  j <- b
  pure [i, j]

-- | Exercise 3
triples :: Int -> Array (Array Int)
triples n = do
  a <- 1 .. n
  b <- a .. n
  c <- b .. n
  guard $ a * a + b * b == c * c
  pure [a, b, c]

-- | Exercise 4
firstFactor :: Int -> Int
firstFactor n = fromMaybe n $ head $ filter (\i -> mod n i == zero) (2 .. n)

factorizations :: Int -> Array (Array Int)
factorizations n = do
  x <- firstFactor n .. n
  y <- x .. n
  guard $ x * y == n
  pure [x, y]

