# Chapter 7

## Applicative Type Class

1. (Easy) Use `lift2` to write lifted versions of the numeric operators `+`,
   `-`, `*` and `/` which work with optional arguments.

``` haskell
maybeAdd :: Maybe Number -> Maybe Number -> Maybe Number
maybeAdd a b = lift2 (+) a b

maybeSubtract :: Maybe Number -> Maybe Number -> Maybe Number
maybeSubtract a b = lift2 (-) a b

maybeMultiply :: Maybe Number -> Maybe Number -> Maybe Number
maybeMultiply a b = lift2 (*) a b

maybeDivide :: Maybe Number -> Maybe Number -> Maybe Number
maybeDivide a b = lift2 (/) a b
```

2. (Medium) Convice yourself that the definition of `lift3` given above in
   terms of `<$>` and `<*>` does type check.

``` haskell
map :: forall a b. (a -> b) -> f a -> f b
apply :: forall a b. f (a -> b) -> f a -> f b

f :: a -> b -> c -> d
x :: f a
y :: f b
z :: f c

f <$> x :: f (b -> c -> d)
f <$> x <*> y :: f (c -> d)
f <$> x <*> y <*> z :: f d
```

3. (Difficult) Write a function `combineMaybe` which has type `forall a f.
   Applicative f => Maybe (f a) -> f (Maybe a)`. This function takes an
   optional computation with side-effects, and returns a side-effecting
   computation which has an optional result.

``` haskell
combineMaybe :: forall a f. Applicative f => Maybe (f a) -> f (Maybe a)
combineMaybe Nothing = pure Nothing
combineMaybe (Just x) = Just <$> x
```

