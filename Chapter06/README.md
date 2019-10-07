# Chapter 6

## Show Me!

1. (Easy) Use the `showShape` function from the previous chapter to define a
   `Show` instance for the `Shape` type.

``` haskell
instance showShape' :: Show Shape where
  show shape = showShape shape
```

