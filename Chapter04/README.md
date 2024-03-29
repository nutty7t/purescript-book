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

# Comprehensions

1. (Easy) Use the `factors` function to define a function `isPrime` which tests
   if its integer argument is prime or not.

``` haskell
isPrime :: Int -> Boolean
isPrime n = n > 1 && (length $ factors n) == 1
```

2. (Medium) Write a function which uses do notation to find the *cartesian
   product* of two arrays, i.e. the set of all pairs of elements `a`, `b`,
   where `a` is an element of the first array, and `b` is an element of the
   second.

``` haskell
-- | TBH, I don't really understand how 'do' expressions really work. I imagine
-- | that things will make more sense when I learn more about monads. But for
-- | now, in my head, it's not dissimilar to a nested list comprehension in
-- | Python: [(i, j) for i in a for j in b].
product :: forall a. Array a -> Array a -> Array (Array a)
product a b = do
  i <- a
  j <- b
  pure [i, j]
```

3. (Medium) A *Pythagorean triple* is an array of numbers `[a, b, c]` such that
   `a² + b² = c²`. Use the `guard` function in an array comprehension to write
   a function `triples` which takes a number `n` and calculates all Pythagorean
   triples whose components are less than `n`. Your function should have type
   `Int -> Array (Array Int)`. 

``` haskell
triples :: Int -> Array (Array Int)
triples n = do
  a <- 1 .. n
  b <- a .. n
  c <- b .. n
  guard $ a * a + b * b == c * c
  pure [a, b, c]
```

4. (Difficult) Write a function `factorizations` which produces all
   *factorizations* of an integer `n`, i.e. arrays of integers whose product is
   `n`. *Hint*: for an integer greater than 1, break the problem down into two
   subproblems: finding the first factor, and finding the remaining factors.

``` haskell
firstFactor :: Int -> Int
firstFactor n = fromMaybe n $ head $ filter (\i -> mod n i == zero) (2 .. n)

factorizations :: Int -> Array (Array Int)
factorizations n = do
  x <- firstFactor n .. n
  y <- x .. n
  guard $ x * y == n
  pure [x, y]
```

# Folds

1. (Easy) Use `foldl` to test whether an array of boolean values are all true.

``` haskell
conjunction :: Array Boolean -> Boolean
conjunction = foldl (&&) true
```

2. (Medium) Characterize those arrays `xs` for which the function `foldl (==)
   false xs` returns true.

We can modeling `foldl` as a finite state machine. Every time an element of the
array gets folded over (the "transitions"), the value of the accumulator (the
"state") gets "updated." We can observe that `true` elements are self-looping
transitions that don't change the value of the accumulator. Only `false`
elements toggle the state back and forth between `true` and `false`.

```
         +------+   +-------------------------+  +------+
         |      |   |                         |  |      |
         |      |   |         == false        |  |      |
         |      |   |                         v  v      |
         |    +-------+                     +------+    |
== true  |    | false |                     | true |    |  == true
         |    +-------+                     +------+    |
         |      ^   ^                         |  |      |
         |      |   |         == false        |  |      |
         |      |   |                         |  |      |
         +------+   +-------------------------+  +------+
```

The initial state is `false`. It's easy to see that any arrays that make the
expression `foldl (==) false xs` evaluate to `true` are arrays that have an odd
number of `false` elements.

3. (Medium) Rewrite the `fib` function in tail recursive form using an
   accumulator parameter:

``` haskell
fib :: Int -> Int
fib 0 = 1
fib 1 = 1
fib n = fib' (n - 2) 1 1
  where
    fib' :: Int -> Int -> Int -> Int
    fib' 0 x y = x + y
    fib' a x y = fib' (a - 1) y (x + y)
```

4. (Medium) Write `reverse` in terms of `foldl`.

``` haskell
reverse :: forall a. Array a -> Array a
reverse = foldl (\xs x -> [x] <> xs) []
```

# Virtual Filesystem

1. (Easy) Write a function `onlyFiles` which returns all *files* (not
   directories) in all subdirectories of a directory.

``` haskell
onlyFiles :: Path -> Array Path
onlyFiles dir = filter (not <<< isDirectory) $ allFiles dir
```

2. (Medium) Write a fold to determine the largest and smallest files in the
   filesystem.

``` haskell
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
```

My initial attempt was to do something like `foldl smaller root $ onlyFiles
root`. But `root` is not a file, so that would be incorrect. Instead, I split
the list into its head and tail, and used the head as the initial accumulator
value and folded over the tail. Pattern matching is not covered until the next
chapter (shhhh...), but the example usage for `uncons` in the Pursuit
documentation gave me enough context to use it.

3. (Difficult) Write a function `whereIs` to search for a file by name. The
   function should return a value of type `Maybe Path`, indicating the
   directory containing the file, if it exists. It should behave as follows:

   > ``` haskell
   > > whereIs "/bin/ls"
   > Just (/bin/)
   > 
   > > whereIs "/bin/cat"
   > Nothing
   > ```

   *Hint*: Try to write this function as an array comprehension using do
   notation.

``` haskell
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
```

^ bad beginner solution

