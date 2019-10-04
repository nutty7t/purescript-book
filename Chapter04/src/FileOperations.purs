module FileOperations where

import Prelude

import Control.MonadPlus (guard)
import Data.Array (concat, concatMap, cons, filter, foldl, foldr, head, uncons, (:))
import Data.Function (flip)
import Data.Maybe (Maybe(..))
import Data.Path (Path, isDirectory, filename, ls, root, size)

allFiles :: Path -> Array Path
allFiles root = root : concatMap allFiles (ls root)

allFiles' :: Path -> Array Path
allFiles' file = file : do
  child <- ls file
  allFiles' child

-- | Exercise 1
onlyFiles :: Path -> Array Path
onlyFiles dir = filter (not <<< isDirectory) $ allFiles dir

-- | Exercise 2
smaller :: Path -> Path -> Path
smaller a b = if size a < size b then a else b

smallest :: Maybe Path
smallest = case uncons $ onlyFiles root of
  Just { head: x, tail: xs } -> Just $ foldl smaller x xs
  Nothing -> Nothing

bigger :: Path -> Path -> Path
bigger a b = if size a > size b then a else b

biggest :: Maybe Path
biggest = case uncons $ onlyFiles root of
  Just { head: x, tail: xs } -> Just $ foldl bigger x xs
  Nothing -> Nothing

-- | Exercise 3
whereIs :: String -> Maybe Path
whereIs name = head $ search root
  where
    search :: Path -> Array Path
    search path = (parent path) <> do
      child <- ls path
      search child
        where
          parent :: Path -> Array Path
          parent file = do
            child <- ls file
            guard $ (filename child) == name
            pure file

