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

