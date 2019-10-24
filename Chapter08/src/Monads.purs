module Monads where

import Prelude

import Data.Array (foldM, head, nubBy, sort, tail)
import Data.List (List(..))
import Data.Maybe (Maybe)

-- | Exercise 1
third :: forall a. Array a -> Maybe a
third xs = do
  i <- tail xs
  j <- tail i
  head j

third' :: forall a. Array a -> Maybe a
third' xs =
  tail xs >>= \i ->
    tail i >>= \j ->
      head j

-- | Exercise 2
sums :: Array Int -> Array Int
sums xs = nubBy compare $ sort $ foldM (\x y -> [x, x + y]) 0 xs

-- | Exercise 5
filterM :: forall m a. Monad m => (a -> m Boolean) -> List a -> m (List a)
filterM f Nil = pure Nil
filterM f (Cons x xs) = do
  b <- f x
  xs' <- filterM f xs
  pure if b then (Cons x xs') else xs'

filterM' :: forall m a. Monad m => (a -> m Boolean) -> List a -> m (List a)
filterM' f Nil = pure Nil
filterM' f (Cons x xs) =
  f x >>= \b ->
    (filterM' f xs) >>= \xs' ->
      pure if b then (Cons x xs') else xs'

