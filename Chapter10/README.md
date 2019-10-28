# Chapter 10

## Runtime Representation

1. (Easy) What are the runtime representations of these types?

   ``` haskell
   forall a. a
   forall a. a -> a -> a
   forall a. Ord a => Array a -> Boolean
   ```

   What can you say about the expressions which have these types?

I don't think that `forall a. a` has a runtime representation (?). We can't
possibly know anything concrete about the type. Searching `forall a. a` on
Pursuit yields the result: `undefined :: forall a. a`, so maybe the runtime
representation is simply just JavaScript's `undefined` type.

Are we allowed to add type constraints? `forall a. a -> a -> a` could represent
closed binary operations. E.g. `append :: forall a. Semigroup a => a -> a ->
a`.

``` javascript
var fn = function (dict) {
  function (a) {
    return function (b) {
      return closedOp(dict)(a)(b)
    }
  }
}
```

The `Ord` type constraint implies that the elements of the `Array a` are
orderable. Since it returns a `Boolean`, we can infer that it's probably some
sort of predicate. It could be the type signature of a function that tests if
an array is sorted.

``` javascript
var sorted = function (dict) {
  return function (arr) {
    // ...
      isSorted = isSorted && eq(dict)(arr[i])(arr[j])
    // ...
    return isSorted
  }
}
```

2. (Medium) Try using the functions defined in the `purescript-arrays` package,
   calling them from JavaScript, by compiling the library using `pulp build`
   and importing modules using the `require` function in NodeJS. *Hint*: you
   may need to configure the output path so that the generated CommonJS modules
   are available on the NodeJS module path.

``` sh
spago build
node
```

``` javascript
> const array = require('./output/Data.Array/foreign')
undefined
> array.length([1, 2, 3])
3
> array.cons(1)([2, 3])
[ 1, 2, 3 ]
> array.reverse([1, 2, 3])
[ 3, 2, 1 ]
```

## Foreign Function Interface (FFI)

1. (Medium) Write a wrapper for the `confirm` method on the JavaScript `window`
   object, and add your foreign function to the `Effect.Alert` module.

``` javascript
exports.confirm = function (msg) {
  return function () {
    return window.confirm(msg)
  }
}
```

``` haskell
-- | src/Effect/Alert.purs
foreign import confirm :: String -> Effect Boolean

-- | src/Main.purs
main :: Effect Unit
main = do
  alert "It works! FFI works!"
  result <- confirm "Do you trust me?"
  if result
    then alert "Then Jump!"
    else alert "T.T"
```

2. (Medium) Write a wrapper for the `removeItem` method on the `localStorage`
   object, and add your foreign function to the `Effect.Storage` module.

``` javascript
exports.removeItem = function (key) {
  return function () {
    return window.localStorage.removeItem(key)
  }
}
```

``` haskell
foreign import removeItem :: String -> Effect Unit
```

