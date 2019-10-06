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

## Algebraic Data Types

1. (Easy) Construct a value of type `Shape` which represents a circle centered
   at the origin with radius `10.0`.

``` haskell
circle :: Shape
circle = Circle p 10.0
  where
    p :: Point
    p = Point { x: 0.0, y: 0.0 }
```

2. (Medium) Write a function from `Shape`s to `Shape`s, which scales its
   argument by a factor of `2.0`, center the origin.

``` haskell
origin :: Point
origin = Point { x: 0.0, y: 0.0 }

dilate :: Number -> Point -> Point
dilate f (Point { x, y }) = Point { x: (x * f), y: (y * f) }

scale2 :: Shape -> Shape
scale2 (Circle c r) = Circle origin (r * 2.0)
scale2 (Rectangle c w h) = Rectangle origin (w * 2.0) (h * 2.0)
scale2 (Line start end) = Line (dilate 2.0 start) (dilate 2.0 end)
scale2 (Text p text) = Text origin text
```

3. (Medium) Write a function which extracts the text from a `Shape`. It should
   return `Maybe String`, and use the `Nothing` constructor if the the input is
   not constructed using `Text`.

``` haskell
extractText :: Shape -> Maybe String
extractText (Text p text) = Just text
extractText _ = Nothing
```

## More Abstract Data Types

1. (Medium) Extend the vector graphics library with a new operation `area`
   which computes the area of a `Shape`. For the purposes of this exercise, the
   area of a piece of text is assumed to be zero.

``` haskell
area :: Shape -> Number
area (Circle _ r) = pi * r * r
area (Rectangle _ w h) = w * h
area _ = 0.0
```

2. (Difficult) Extend the `Shape` type with a new data constructor `Clipped`,
   which clips another `Picture` to a rectangle. Extend the `shapeBounds`
   function to compute the bounds of a clipped picture. Note that this makes
   `Shape` into a recursive data type.

``` haskell
-- | This makes `Shape` into a recursive type because `Picture` is an alias for
-- | `Array Shape`.
data Shape
  = Circle Point Number
  | Rectangle Point Number Number
  | Line Point Point
  | Text Point String
  | Clipped Picture

showShape :: Shape -> String
-- ...
showShape (Clipped p) =
  "Clipped [picture: " <> (show $ map showShape p) <> "]"

showBounds :: Bounds -> String
-- ...
shapeBounds (Clipped p) = bounds p
```

``` haskell
> showBounds $ shapeBounds $ Clipped [(Rectangle (Point { x: 1.0, y: 1.0 }) 4.0 5.0), (Rectangle (Point { x: 0.0, y: 0.0 }) 4.0 5.0)]

"Bounds [top: -2.5, left: -2.0, bottom: 3.5, right: 3.0]"
```
