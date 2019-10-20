module Tree where

import Prelude

import Data.Array (foldMap, foldl, foldr)
import Data.Foldable (class Foldable)
import Data.Traversable (class Traversable, sequence, traverse)

data Tree a = Leaf | Branch (Tree a) a (Tree a)

instance showTree :: Show a => Show (Tree a) where
  show Leaf = "•"
  show (Branch l n r) =
    "(" <> " " <> show l <> " " <> show n <> " " <> show r <> " " <> ")"

instance functorTree :: Functor Tree where
  map fn Leaf = Leaf
  map fn (Branch l n r) = Branch (fn <$> l) (fn n) (fn <$> r)

instance foldableTree :: Foldable Tree where
  foldl _  a Leaf = a
  foldl f a (Branch l n r) = foldl f (f (foldl f a l) n) r
  foldr _ a Leaf = a
  foldr f a (Branch l n r) = foldr f (f n (foldr f a r)) l
  foldMap _ Leaf = mempty
  foldMap f (Branch l n r) = foldMap f l <> f n <> foldMap f r

instance traversableTree :: Traversable Tree where
  traverse _ Leaf = pure Leaf
  traverse f (Branch l n r) = Branch <$> traverse f l <*> f n <*> traverse f r
  sequence Leaf = pure Leaf
  sequence (Branch l n r) = Branch <$> sequence l <*> n <*> sequence r

-- |   3
-- |  / \
-- | 4   5
exampleTree :: Tree Int
exampleTree = Branch (Branch Leaf 4 Leaf) 3 (Branch Leaf 5 Leaf)

