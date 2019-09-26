# Chapter 4

## Recursion

1. (Easy) Write a recursive function which returns `true` if and only if its
   input is an even integer.

``` haskell
even :: Int -> Boolean
even 0 = true
even 1 = false
even n = even $ abs n - 2
```

2. (Medium) Write a recursive function which counts the number of even integers
   in an array. *Hint*: the function `head` (also available in `Data.Array`)
   can be used to find the first element in a non-empty array.

``` haskell
-- | My horrendous first attempt...
countEven :: Array Int -> Int
countEven arr = _countEven arr zero
  where
    _countEven :: Array Int -> Int -> Int
    _countEven arr acc =
      if null arr
        then acc
        else
          if even $ fromMaybe 1 $ head arr
            then _countEven (fromMaybe [] $ tail arr) acc + 1
            else _countEven (fromMaybe [] $ tail arr) acc

-- | Here is another attempt without an accumulator.
-- | It's still kind of ugly. 👹
countEven2 :: Array Int -> Int
countEven2 arr =
  if null arr
    then 0
    else
      if even $ fromMaybe 1 $ head arr
        then 1 + (countEven2 $ fromMaybe [] $ tail arr)
        else countEven2 $ fromMaybe [] $ tail arr

-- | This one is not even recursive, but it makes me feel better.
countEven3 :: Array Int -> Int
countEven3 arr = length $ filter even arr

-- | This final attempt removes the nested conditional expression by defining
-- | the Boolean to Int casting as an auxiliary function in the where clause.
-- | Unwrapping values from Maybe types seems so verbose. Also, what are the
-- | conventions for indenting the 'where' keyword?
countEven4 :: Array Int -> Int
countEven4 arr =
  if null arr
    then 0
    else (int $ even $ fromMaybe 1 $ head arr) +
         (countEven4 $ fromMaybe [] $ tail arr)
  where
    int :: Boolean -> Int
    int true = 1
    int false = 0
```

## Filtering

1. (Easy) Use the `map` or `<$>` function to write a function which calculates
   the squares of an array of numbers.

``` haskell
squareArray :: Array Number -> Array Number
squareArray arr = (\x -> x * x) <$> arr
```

2. (Easy) Use the `filter` function to write a function which removes the
   negative numbers from an array of numbers.

``` haskell
filterPositive :: Array Number -> Array Number
filterPositive arr = filter (\x -> x >= 0.0) arr
```

3. (Medium) Define an infix synonym `<$?>` for `filter`. Rewrite your answer to
   the previous question to use your new operator. Experiment with the
   precendence level and associativity of your operator in PSCi.

``` haskell
infix 0 filter as <$?>
filterPositive :: Array Number -> Array Number
filterPositive arr = (\x -> x >= 0.0) <$?> arr
```

When the precedence level is `0`, we can write `(\x -> x >= 0) <$?> -5 .. 5`
and it works just fine because the precendence level is lower than `..` (`8`).
But when we make the precedence level `10`, we need to write the expression as
`(\x -> x >= 0.0) <$?> (-5 .. 5)`. The **precedence level** indicates how
operators get grouped when there are instances of *different* operators in an
expression.

The **associativity** indicates how operators are grouped when there are
multiple instances of the *same* operator in an expression. If we don't specify
an associativity, then there cannot be multiple instances of the operator:

``` haskell
infix 0 filter as <$?>
even <$?> (\x -> x >= 0) <$?> -5 .. 5
```

We get the following error:

```
Cannot parse an expression that uses multiple instances of the non-associative operator Filter.(<$?>).
Use parentheses to resolve this ambiguity.
```

As the error mentions, we must use parentheses to explicity denote the
associativity of the operators.

``` haskell
even <$?> ((\x -> x >= 0) <$?> -5 .. 5)
```

But we can use `infixl` and `infixr` to specify the associativity of the
operator:

``` haskell
-- | Right-associative filter
infixr 0 filter as <$?>
even <$?> (\x -> x >= 0) <$?> -5 .. 5

-- | I actually don't think that we can make an equivalent expression with a
-- | left-associative operator without reversing the order of parameters in the
-- | the filter function. (Maybe you can. I don't know.)

-- | Left-associative filter
filterFlip :: forall a. Array a -> (a -> Boolean) -> Array a
filterFlip = flip filter
infixl 0 filterFlip as <$?>
(-5 .. 5) <$?> (\x -> x >= 0) <$?> even
```
