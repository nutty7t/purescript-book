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

## More FFI and Generics

1. (Easy) Use `decodeJSON` to parse a JSON document representing a
   two-dimensional JavaScript array of integers, such as `[[1, 2, 3], [4, 5],
   [6]]`. What if the elements are allowed to be null? What if the arrays
   themselves are allowed to be null?

   ``` haskell
   > runExcept $ (decodeJSON "[[1, 2, 3], [4, 5], [6]]" :: F (Array (Array Int)))
   (Right [[1,2,3],[4,5],[6]])
   ```

   If the elements are allowed to be null, then I can change the type
   annotation to encapsulate the `Int` type in a `Maybe` type constructor.

   ``` haskell
   > runExcept $ (decodeJSON "[[1, null, 3], [null, 5], [6]]" :: F (Array (Array (Maybe Int))))
   (Right [[(Just 1),Nothing,(Just 3)],[Nothing,(Just 5)],[(Just 6)]])
   ```

2. (Medium) Convice yourself that the implementation of `savedData` should
   type-check, and write down the inferred types of each subexpression in the
   computation.

``` haskell
item :: Foreign
readNullOrUndefined :: Foreign -> F (Maybe Foreign)
readNullOrUndefined item :: F (Maybe Foreign)

traverse :: forall a b m t. Traversable t => Applicative m => (a -> m b) -> t a -> m (t b)
readString :: Foreign -> F String
traverse readString :: forall t. Traversable t => t Foreign -> F (t String)

bind (>>=) :: forall a b m. Bind m => m a -> (a -> m b) -> m b
bindFlipped (=<<) :: forall m a b. Bind m => (a -> m b) -> m a -> m b
traverse readString =<< readNullOrUndefined item :: F (Maybe String)

json :: Maybe String
decodeJSON :: forall a. Decode a => String -> F a
traverse decodeJSON json :: F (Maybe String)
runExcept :: forall e a. Except e a -> Either e a
type F = Except MultipleErrors
type MultipleErrors = NonEmptyList ForeignError

(runExcept do
 json <- traverse readString =<< readNullOrUndefined item
 traverse decodeJSON json) :: Either (NonEmptyList ForeignError) (Maybe String)
```

3. (Medium) The following data type represents a binary tree with values at the
   leaves:

   ``` haskell
   data Tree a = Leaf a | Branch (Tree a) (Tree a)
   ```

   Derive `Encode` and `Decode` instances for this type using
   `purescript-foreign-generic`, and verify that encoded values can correcly be
   decoded in PSCi.

``` haskell
data Tree a = Leaf a | Branch (Tree a) (Tree a)

derive instance genericTree :: Generic (Tree a) _

instance encodeTree :: Encode a => Encode (Tree a) where
  encode t = genericEncode defaultOptions t

instance decodeTree :: Decode a => Decode (Tree a) where
  decode t = genericDecode defaultOptions t

instance showTree :: Show a => Show (Tree a) where
  show t = genericShow t
```

``` haskell
> runExcept (decodeJSON $ encodeJSON (Branch (Leaf 5) (Leaf 3)) :: F (Tree Int))
(Right (Branch (Leaf 5) (Leaf 3)))
```

``` json
{
  "contents": [
    {
      "contents": 5,
      "tag": "Leaf"
    },
    {
      "contents": 3,
      "tag": "Leaf"
    }
  ],
  "tag": "Branch"
}
```

4. (Difficult) The following `data` type should be represented directly in JSON
   as either an integer or a string:

   ``` haskell
   data IntOrString
     = IntOrString_Int Int
	 | IntOrString_String String
   ```

   Write instances for `Encode` and `Decode` for the `IntOrString` data type
   which implements this behavior, and verify that encoded values can correctly
   be decoded in PSCi.

``` haskell
data IntOrString
  = IntOrString_Int Int
  | IntOrString_String String

derive instance genericIntOrString :: Generic IntOrString _

instance encodeIntOrString :: Encode IntOrString where
  encode = genericEncode defaultOptions

instance decodeIntOrString :: Decode IntOrString where
  decode = genericDecode defaultOptions

instance showIntOrString :: Show IntOrString where
  show = genericShow
```

``` haskell
> runExcept (decode $ encode (IntOrString_Int 7) :: F IntOrString)
(Right (IntOrString_Int 7))
```

