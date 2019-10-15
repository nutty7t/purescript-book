module Applicative where

import Prelude

import Control.Apply (lift2)
import Data.Maybe (Maybe(..))

-- | Exercise 1
maybeAdd :: Maybe Number -> Maybe Number -> Maybe Number
maybeAdd a b = lift2 (+) a b

maybeSubtract :: Maybe Number -> Maybe Number -> Maybe Number
maybeSubtract a b = lift2 (-) a b

maybeMultiply :: Maybe Number -> Maybe Number -> Maybe Number
maybeMultiply a b = lift2 (*) a b

maybeDivide :: Maybe Number -> Maybe Number -> Maybe Number
maybeDivide a b = lift2 (/) a b

-- | Exercise 3
combineMaybe :: forall a f. Applicative f => Maybe (f a) -> f (Maybe a)
combineMaybe Nothing = pure Nothing
combineMaybe (Just x) = Just <$> x

