# Chapter 7

## Applicative Type Class

1. (Easy) Use `lift2` to write lifted versions of the numeric operators `+`,
   `-`, `*` and `/` which work with optional arguments.

``` haskell
maybeAdd :: Maybe Number -> Maybe Number -> Maybe Number
maybeAdd a b = lift2 (+) a b

maybeSubtract :: Maybe Number -> Maybe Number -> Maybe Number
maybeSubtract a b = lift2 (-) a b

maybeMultiply :: Maybe Number -> Maybe Number -> Maybe Number
maybeMultiply a b = lift2 (*) a b

maybeDivide :: Maybe Number -> Maybe Number -> Maybe Number
maybeDivide a b = lift2 (/) a b
```

2. (Medium) Convice yourself that the definition of `lift3` given above in
   terms of `<$>` and `<*>` does type check.

``` haskell
map :: forall a b. (a -> b) -> f a -> f b
apply :: forall a b. f (a -> b) -> f a -> f b

f :: a -> b -> c -> d
x :: f a
y :: f b
z :: f c

f <$> x :: f (b -> c -> d)
f <$> x <*> y :: f (c -> d)
f <$> x <*> y <*> z :: f d
```

3. (Difficult) Write a function `combineMaybe` which has type `forall a f.
   Applicative f => Maybe (f a) -> f (Maybe a)`. This function takes an
   optional computation with side-effects, and returns a side-effecting
   computation which has an optional result.

``` haskell
combineMaybe :: forall a f. Applicative f => Maybe (f a) -> f (Maybe a)
combineMaybe Nothing = pure Nothing
combineMaybe (Just x) = Just <$> x
```

## Applicative Validation

1. (Easy) Use a regular expression validator to ensure that the `state` field
   of the `Address` type contains two alphabetic characters. *Hint*: see the
   source code for `phoneNumberRegex`.

``` haskell
stateRegex :: Regex
stateRegex =
  unsafePartial
    case regex "^[a-zA-Z]{2}$" noFlags of
      Right r -> r

validateAddress :: Address -> V Errors Address
validateAddress (Address o) =
  address <$> (nonEmpty "Street" o.street         *> pure o.street)
          <*> (nonEmpty "City"   o.city           *> pure o.city)
          <*> (matches "State" stateRegex o.state *> pure o.state)
```

2. (Medium) Using the `matches` validator, write a validation function which
   checks that a string is not entirely whitespace. Use it to replace
   `nonEmpty` where appropriate.

``` haskell
whitespaceRegex :: Regex
whitespaceRegex =
  unsafePartial
    case regex "^.*\\S.*$" noFlags of
      Right r -> r

nonEmpty' :: String -> String -> V Errors Unit
nonEmpty' field s = matches field whitespaceRegex s
```

## Traversable Functors

1. (Medium) Write a `Traversable` instance for the following binary tree data
   structure, which combines side-effects from left-to-right:

   ``` haskell
   data Tree a = Leaf | Branch (Tree a) a (Tree a)
   ```

   This corresponds to an in-order traversal of the tree. What about a preorder
   traversal? What about reverse order?

``` haskell
data Tree a = Leaf | Branch (Tree a) a (Tree a)

instance showTree :: Show a => Show (Tree a) where
  show Leaf = "•"
  show (Branch l n r) =
    "(" <> " " <> show l <> " " <> show n <> " " <> show r <> " " <> ")"

instance functorTree :: Functor Tree where
  map fn Leaf = Leaf
  map fn (Branch l n r) = Branch (fn <$> l) (fn n) (fn <$> r)

instance foldableTree :: Foldable Tree where
  foldl _  a Leaf = a
  foldl f a (Branch l n r) = foldl f (f (foldl f a l) n) r
  foldr _ a Leaf = a
  foldr f a (Branch l n r) = foldr f (f n (foldr f a r)) l
  foldMap _ Leaf = mempty
  foldMap f (Branch l n r) = foldMap f l <> f n <> foldMap f r

instance traversableTree :: Traversable Tree where
  traverse _ Leaf = pure Leaf
  traverse f (Branch l n r) = Branch <$> traverse f l <*> f n <*> traverse f r
  sequence Leaf = pure Leaf
  sequence (Branch l n r) = Branch <$> sequence l <*> n <*> sequence r

-- |   3
-- |  / \
-- | 4   5
exampleTree :: Tree Int
exampleTree = Branch (Branch Leaf 4 Leaf) 3 (Branch Leaf 5 Leaf)
```

``` haskell
> map (\x -> x * 2) exampleTree
( ( • 8 • ) 6 ( • 10 • ) )

> foldMap Multiplicative exampleTree
(Multiplicative 60)

> traverse (\x -> 1 .. x) (Branch Leaf 5 Leaf)
[( • 1 • ),( • 2 • ),( • 3 • ),( • 4 • ),( • 5 • )]
```

To get a preorder traversal or a reverse order traversal, all we need to do is
change the order in which the left tree, the root, and the right tree are
evaluated:

```
Preorder: root node, left tree, right tree
Postorder: left tree, right tree, root node
```

2. (Medium) Modify the code to make the `address` field of the `Person` type
   optional using `Data.Maybe`. *Hint*: Use `traverse` to validate a field of
   type `Maybe a`.

``` haskell
newtype Person = Person
  { firstName   :: String
  , lastName    :: String
  , homeAddress :: Maybe Address -- refactor
  , phones      :: Array PhoneNumber
  }

person :: String -> String -> Maybe Address -> Array PhoneNumber -> Person -- refactor
person firstName lastName homeAddress phones =
  Person { firstName, lastName, homeAddress, phones }

examplePerson :: Person
examplePerson =
  person "John" "Smith"
         (Just $ address "123 Fake St." "FakeTown" "CA") -- refactor
         [ phoneNumber HomePhone "555-555-5555"
         , phoneNumber CellPhone "555-555-0000"
         ]

validatePerson :: Person -> V Errors Person
validatePerson (Person o) =
  person <$> (nonEmpty' "First Name" o.firstName *> pure o.firstName)
         <*> (nonEmpty' "Last Name"  o.lastName  *> pure o.lastName)
         <*> traverse validateAddress o.homeAddress -- refactor
         <*> (arrayNonEmpty "Phone Numbers" o.phones *> traverse validatePhoneNumber o.phones)

validatePersonAdo :: Person -> V Errors Person
validatePersonAdo (Person o) = ado
  firstName   <- (nonEmpty' "First Name" o.firstName *> pure o.firstName)
  lastName    <- (nonEmpty' "Last Name"  o.lastName  *> pure o.lastName)
  address     <- traverse validateAddress o.homeAddress -- refactor
  numbers     <- (arrayNonEmpty "Phone Numbers" o.phones *> traverse validatePhoneNumber o.phones)
  in person firstName lastName address numbers
```

3. (Difficult) Try to write `sequence` in terms of `traverse`. Can you write
   `traverse` in terms of `sequence`?

``` haskell
sequence = traverse identity
traverse f = sequence <<< map f
```

