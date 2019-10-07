# Chapter 6

## Show Me!

1. (Easy) Use the `showShape` function from the previous chapter to define a
   `Show` instance for the `Shape` type.

``` haskell
instance showShape' :: Show Shape where
  show shape = showShape shape
```

## Common Type Classes

1. (Easy) The following newtype represents a complex number:

   ``` haskell
   newtype Complex = Complex
     { real :: Number
     , imaginary :: Number
     }
   ```
   
   Define `Show` and `Eq` instances for `Complex`.

``` haskell
instance showComplex :: Show Complex where
  show (Complex { real, imaginary }) =
    show real <> " + " <> show imaginary <> "i"

instance eqComplex :: Eq Complex where
  eq (Complex { real: r1, imaginary: i1 }) (Complex { real: r2, imaginary: i2 }) =
    r1 == r2 && i1 == i2
```

## More Type Classes

1. (Easy) The following declaration defines a type of non-empty arrays of
   elements of type `a`:

   ``` haskell
   data NonEmpty a = NonEmpty a (Array a)
   ```

   Write an `Eq` instance for the type `NonEmpty a` which reuses the instances for
   `Eq a` and `Eq (Array a)`.

``` haskell
instance eqNonEmpty :: Eq a => Eq (NonEmpty a) where
  eq (NonEmpty a x) (NonEmpty b y) = (a == b) && (x == y)
```

2. (Medium) Write a `Semigroup` instance for `NonEmpty a` by reusing the
   `Semigroup` instance for `Array`.

``` haskell
instance semigroupNonEmpty :: Semigroup (NonEmpty a) where
  append (NonEmpty a x) (NonEmpty b y) = NonEmpty a (x <> y)
```

3. (Medium) Write a `Functor` instance for `NonEmpty`.

``` haskell
instance functorNonEmpty :: Functor NonEmpty where
  map f (NonEmpty a x) = NonEmpty (f a) (f <$> x)
```

``` haskell
> :paste
… id :: forall a. a -> a
… id a = a
…
> id <$> NonEmpty 0 [1, 2, 3])
[0,1,2,3]
```

4. (Medium) Given any type `a` with an instance of `Ord`, we can add a new
   "infinite" value which is greater than any other value:

   ``` haskell
   data Extended a = Finite a | Infinite
   ```

   Write an `Ord` instance for `Extended a` which reuses the `Ord` instance for
   `a`.

``` haskell
instance eqExtended :: Eq a => Eq (Extended a) where
  eq (Finite a) (Finite b) = a == b
  eq Infinite Infinite = true
  eq _ _ = false

instance ordExtended :: Ord a => Ord (Extended a) where
  compare (Finite a) (Finite b) = compare a b
  compare Infinite (Finite _) = GT
  compare (Finite _) Infinite = LT
  compare Infinite Infinite = EQ
```

Are infinities equal to each other? Idk, but Python 3 says they are:

``` python
>>> import math
>>> math.inf == math.inf
True
```

5. (Difficult) Write a `Foldable` instance for `NonEmpty`. *Hint*: reuse the
   `Foldable` instance for arrays.

``` haskell
instance foldableNonEmpty :: Foldable NonEmpty where
  foldr f z (NonEmpty a x) = f a (foldr f z x)
  foldl f z (NonEmpty a x) = foldl f (f z a) x
  foldMap f (NonEmpty a x) = (f a) <> foldMap f x
```

``` haskell
> foldl (-) 0 (NonEmpty 0 [1, 2, 3, 4, 5])
-15

> foldr (-) 0 (NonEmpty 0 [1, 2, 3, 4, 5])
-3

> foldMap show (NonEmpty 0 [1, 2, 3, 4, 5])
"012345"
```

6. (Difficult) Given a type constructor `f` which defines an ordered container
   (and so has a `Foldable` instance), we can create a new container type which
   includes an extra element at the front:

   ``` haskell
   data OneMore f a = OneMore a (f a)
   ```

   The container `OneMore f` also has an ordering, where the new element comes
   before any element of `f`. Write a `Foldable` instance for `OneMore f`:

   ``` haskell
   instance foldableOneMore :: Foldable f => Foldable (OneMore f) where
   ...
   ```

``` haskell
instance foldableOneMore :: Foldable f => Foldable (OneMore f) where
  foldr f z (OneMore a x) = f a (foldr f z x)
  foldl f z (OneMore a x) = foldl f (f z a) x
  foldMap f (OneMore a x) = (f a) <> foldMap f x
```

