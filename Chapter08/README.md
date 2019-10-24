# Chapter 8

## Monads

1. (Easy) Look up the types of the `head` and `tail` functions from the
   `Data.Array` module in the `purescript-arrays` package. Use do notation with
   the `Maybe` monad to combine these functions into a function `third` which
   returns the third element of an array with three or more elements. Your
   function should return an appropriate `Maybe` type.

``` haskell
head :: forall a. Array a -> Maybe a
tail :: forall a. Array a -> Maybe (Array a)
```

``` haskell
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
```

2. (Medium) Write a function `sums` which uses `foldM` to determine all
   possible totals that could be made using a set of coins. The coins will be
   specified as an array which contains the value of each coin. Your function
   should have the following result:

   ``` haskell
   > sums []
   [0]

   > sums [1, 2, 10]
   [1,2,3,10,11,12,13]
   ```

   *Hint*: This function can be written as a one-liner using `foldM`. You might
   want to use the `nub` and `sort` functions to remove duplicates and sort the
   result respectively.

``` haskell
sums :: Array Int -> Array Int
sums xs = nubBy compare $ sort $ foldM (\x y -> [x, x + y]) 0 xs
```

3. (Medium) Confirm that the `ap` function and the `apply` operator agree for
   the `Maybe` monad.

``` haskell
> (+) <$> (Just 3) <*> (Just 4)
(Just 7)

> (+) <$> (Just 3) <*> Nothing
Nothing

> ((+) <$> (Just 3)) `ap` (Just 4)
(Just 7)

> ((+) <$> (Just 3)) `ap` Nothing
Nothing
```

4. (Medium) Verify that the monad laws hold for the `Monad` instance for the
   `Maybe` type, as defined in the `purescript-maybe` package.

``` haskell
> -- Left Identity
> (pure 7 :: Maybe Int) >>= Just
(Just 7)

> :paste
… (do
…   x <- pure 7
…   pure x) :: Maybe Int
…
(Just 7)

> Just 7
(Just 7)

> -- Right Identity
> (Nothing :: Maybe Int) >>= pure
Nothing

> :paste
… do
…   x <- Nothing :: Maybe Int
…   pure x
…
Nothing

> (Just 7) >>= pure
(Just 7)

> :paste
… do
…   x <- Just 7
…   pure x
…
(Just 7)

> -- Associativity
> foo = Just <<< range 1
> bar = Just <<< replicate 3

> (Just 3) >>= foo >>= bar
(Just [[1,2,3],[1,2,3],[1,2,3]])

> :paste
… do
…   x <- Just 3
…   y <- foo x
…   bar y
…
(Just [[1,2,3],[1,2,3],[1,2,3]])

> (Just 3) >>= (\x -> foo x >>= bar)
(Just [[1,2,3],[1,2,3],[1,2,3]])

> :paste
… do
…   y <- do
…     x <- Just 3
…     foo x
…   bar y
…
(Just [[1,2,3],[1,2,3],[1,2,3]])
```

5. (Medium) Write a function `filterM` which generalizes the `filter` function
   on lists. Your function should have the following type signature:

   ``` haskell
   filterM :: forall m a. Monad m => (a -> m Boolean) -> List a -> m (List a)
   ```

   Test your function in PSCi using the `Maybe` and `Array` monads.

``` haskell
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
```

6. (Difficult) Every monad has a default `Functor` instance given by:

   ``` haskell
   map f a = do
     x <- a
     pure (f x)
   ```

   Use the monad laws to prove that for any monad, the following holds:

   ``` haskell
   lift2 f (pure a) (pure b) = pure (f a b)
   ```

   where the `Applicative` instance uses the `ap` function defined above.
   Recall that `lift2` was defined as follows:

   ``` haskell
   lift2 :: forall f a b c. Applicative f => (a -> b -> c) -> f a -> f b -> f c
   lift2 f a b = f <$> a <*> b
   ```

``` haskell
f <$> (pure a) = pure a >>= (\x -> pure $ f x) -- <=> (left-identity)
f <$> (pure a) = pure (f (pure a))

f <$> (pure a) <*> (pure b) = (pure (f (pure a))) <*> (pure b) -- <=> (homomorphism)
f <$> (pure a) <*> (pure b) = pure (f a b)
```

