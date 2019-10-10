module TypeClasses where

import Prelude

import Data.Array (cons, foldMap, foldl, foldr)
import Data.Foldable (class Foldable, maximum)
import Data.Maybe (fromJust, fromMaybe)
import Data.String.Utils (repeat)

-- | Exercise 1 (Common Type Classes)
newtype Complex = Complex
  { real :: Number
  , imaginary :: Number
  }

instance showComplex :: Show Complex where
  show (Complex { real, imaginary }) =
    show real <> " + " <> show imaginary <> "i"

instance eqComplex :: Eq Complex where
  eq (Complex { real: r1, imaginary: i1 }) (Complex { real: r2, imaginary: i2 }) =
    r1 == r2 && i1 == i2

-- | Exercise 1 (More Type Classes)
data NonEmpty a = NonEmpty a (Array a)

instance eqNonEmpty :: Eq a => Eq (NonEmpty a) where
  eq (NonEmpty a x) (NonEmpty b y) = (a == b) && (x == y)

-- | Exercise 2 (More Type Classes)
instance showNonEmpty :: Show a => Show (NonEmpty a) where
  show (NonEmpty a x) = show (cons a x)

instance semigroupNonEmpty :: Semigroup (NonEmpty a) where
  append (NonEmpty a x) (NonEmpty b y) = NonEmpty a (x <> y)

-- | Exercise 3 (More Type Classes)
instance functorNonEmpty :: Functor NonEmpty where
  map f (NonEmpty a x) = NonEmpty (f a) (f <$> x)

-- | Exercise 4 (More Type Classes)
data Extended a = Finite a | Infinite

instance eqExtended :: Eq a => Eq (Extended a) where
  eq (Finite a) (Finite b) = a == b
  eq Infinite Infinite = true
  eq _ _ = false

instance ordExtended :: Ord a => Ord (Extended a) where
  compare (Finite a) (Finite b) = compare a b
  compare Infinite (Finite _) = GT
  compare (Finite _) Infinite = LT
  compare Infinite Infinite = EQ

-- | Exercise 5 (More Type Classes)
instance foldableNonEmpty :: Foldable NonEmpty where
  foldr f z (NonEmpty a x) = f a (foldr f z x)
  foldl f z (NonEmpty a x) = foldl f (f z a) x
  foldMap f (NonEmpty a x) = (f a) <> foldMap f x

-- | Exercise 6 (More Type Classes)
data OneMore f a = OneMore a (f a)

instance foldableOneMore :: Foldable f => Foldable (OneMore f) where
  foldr f z (OneMore a x) = f a (foldr f z x)
  foldl f z (OneMore a x) = foldl f (f z a) x
  foldMap f (OneMore a x) = (f a) <> foldMap f x

-- | Exercise 1 (Advanced Type Classes)
partialMax :: Partial => Array Int -> Int
partialMax a = fromJust $ maximum a

-- | Exercise 2 (Advanced Type Classes)
newtype Multiply = Multiply Int

instance semigroupMultiply :: Semigroup Multiply where
  append (Multiply n) (Multiply m) = Multiply (n * m)

instance monoidMultiply :: Monoid Multiply where
  mempty = Multiply 1

class Monoid m <= Action m a where
  act :: m -> a -> a

instance repeatAction :: Action Multiply String where
  act (Multiply n) s = fromMaybe "" $ repeat n s

-- | Exercise 3 (Advanced Type Classes)
instance arrayAction :: Action m a => Action m (Array a) where
  act m f = act m <$> f

-- | Exercise 4 (Advanced Type Classes)
newtype Self m = Self m

instance selfAction :: Monoid m => Action m (Self m) where
  act a (Self b) = Self (a <> b)

