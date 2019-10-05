# Chapter 5

## Pattern Matching

1. (Easy) Write the factorial function using pattern matching. *Hint*. Consider
   the two cases zero and non-zero inputs.

``` haskell
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)
```

2. (Medium) Look up *Pascal's Rule* for computing binomial coefficients. Use it
   to write a function which computes binomial coefficients using pattern
   matching.

``` haskell
choose :: Int -> Int -> Int
choose 0 0 = 1
choose n 0 = 1
choose n k
  | n == k = 1
  | otherwise = add (choose (n - 1) (k - 1)) (choose (n - 1) k)
```

## Records

1. (Easy) Write a function `sameCity` which uses record patterns to test
   whether two `Person` records belong to the same city.

``` haskell
sameCity :: Person -> Person -> Boolean
sameCity { address: { city: x } } { address: { city: y } } = x == y
```

2. (Medium) What is the most general type of the `sameCity` function, taking
   into account row polymorphism? What about the `livesInLA` function defined
   above?

```
sameCity :: forall a b c d. { address :: { city :: String | a } | b } -> { address :: { city :: String | c } | d } -> Boolean
livesInLA :: forall a b. { address :: { city :: String | a } | b } -> Boolean
```

3. (Medium) Write a function `fromSingleton` which uses an array literal
   pattern to extract the sole member of a singleton array. If the array is not
   a singleton, your function should return a provided default value. Your
   function should have type `forall a. a -> Array a -> a`.

``` haskell
fromSingleton :: forall a. a -> Array a -> a
fromSingleton d [e] = e
fromSingleton d arr = d
```

