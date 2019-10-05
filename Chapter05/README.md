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

