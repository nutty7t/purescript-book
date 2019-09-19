# Chapter 2

1. (Easy) Use the `pi` constant, which is defined in the `Math` module, to
   write a function `circleArea` which computes the area of a circle with a
   given radius. Test your function using PSCi (*Hint*: don't forget to import
   `pi` by modifying the `import Math` statement).

``` haskell
import Math

circleArea r = pi * r * r
```

2. (Medium) Use `bower install` to install the `purescript-globals` package as
   a dependency. Test out its functions in PSCi (*Hint*: you can use the
   `:browse` command in PSCi to browse the contents of a module).

``` haskell
> import Global
> import Math

> toPrecision 3 pi
(Just "3.14")

> toFixed 9000 pi
Nothing

> readFloat "3e10"
30000000000.0

> isFinite pi
true

> isFinite infinity
false
```
