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

## More Type Classes

1. (Easy) The following declaration defines a type of non-empty arrays of
   elements of type `a`:

   ``` haskell
   data NonEmpty a = NonEmpty a (Array a)
   ```

   Write an `Eq` instance for the type `NonEmpty a` which reuses the instances for
   `Eq a` and `Eq (Array a)`.

``` haskell
instance eqNonEmpty :: Eq a => Eq (NonEmpty a) where
  eq (NonEmpty a x) (NonEmpty b y) = (a == b) && (x == y)
```

2. (Medium) Write a `Semigroup` instance for `NonEmpty a` by reusing the
   `Semigroup` instance for `Array`.

``` haskell
instance semigroupNonEmpty :: Semigroup (NonEmpty a) where
  append (NonEmpty a x) (NonEmpty b y) = NonEmpty a (x <> y)
```

3. (Medium) Write a `Functor` instance for `NonEmpty`.

``` haskell
instance functorNonEmpty :: Functor NonEmpty where
  map f (NonEmpty a x) = NonEmpty (f a) (f <$> x)
```

``` haskell
> :paste
… id :: forall a. a -> a
… id a = a
…
> id <$> NonEmpty 0 [1, 2, 3]
[0,1,2,3]
```

4. (Medium) Given any type `a` with an instance of `Ord`, we can add a new
   "infinite" value which is greater than any other value:

   ``` haskell
   data Extended a = Finite a | Infinite
   ```

   Write an `Ord` instance for `Extended a` which reuses the `Ord` instance for
   `a`.

``` haskell
instance eqExtended :: Eq a => Eq (Extended a) where
  eq (Finite a) (Finite b) = a == b
  eq Infinite Infinite = true
  eq _ _ = false

instance ordExtended :: Ord a => Ord (Extended a) where
  compare (Finite a) (Finite b) = compare a b
  compare Infinite (Finite _) = GT
  compare (Finite _) Infinite = LT
  compare Infinite Infinite = EQ
```

Are infinities equal to each other? Idk, but Python 3 says they are:

``` python
>>> import math
>>> math.inf == math.inf
True
```

5. (Difficult) Write a `Foldable` instance for `NonEmpty`. *Hint*: reuse the
   `Foldable` instance for arrays.

``` haskell
instance foldableNonEmpty :: Foldable NonEmpty where
  foldr f z (NonEmpty a x) = f a (foldr f z x)
  foldl f z (NonEmpty a x) = foldl f (f z a) x
  foldMap f (NonEmpty a x) = (f a) <> foldMap f x
```

``` haskell
> foldl (-) 0 (NonEmpty 0 [1, 2, 3, 4, 5])
-15

> foldr (-) 0 (NonEmpty 0 [1, 2, 3, 4, 5])
-3

> foldMap show (NonEmpty 0 [1, 2, 3, 4, 5])
"012345"
```

6. (Difficult) Given a type constructor `f` which defines an ordered container
   (and so has a `Foldable` instance), we can create a new container type which
   includes an extra element at the front:

   ``` haskell
   data OneMore f a = OneMore a (f a)
   ```

   The container `OneMore f` also has an ordering, where the new element comes
   before any element of `f`. Write a `Foldable` instance for `OneMore f`:

   ``` haskell
   instance foldableOneMore :: Foldable f => Foldable (OneMore f) where
   ...
   ```

``` haskell
instance foldableOneMore :: Foldable f => Foldable (OneMore f) where
  foldr f z (OneMore a x) = f a (foldr f z x)
  foldl f z (OneMore a x) = foldl f (f z a) x
  foldMap f (OneMore a x) = (f a) <> foldMap f x
```

## Advanced Type Classes

1. (Medium) Define a partial function which finds the maximum of a non-empty
   array of integers. Your function should have type `Partial => Array Int ->
   Int`. Test out your function in PSCi using `unsafePartial`. *Hint*: Use the
   `maximum` function from `Data.Foldable`.

``` haskell
partialMax :: Partial => Array Int -> Int
partialMax a = fromJust $ maximum a
```

2. (Medium) The `Action` class is a multi-parameter type class which defines an
   action of one type on another:

   ``` haskell
   class Monoid m <= Action m a where
     act :: m -> a -> a
   ```

   An *action* is a function which describes how monoidal values can be used to
   modify a value of another type. There are two laws for the `Action` type
   class.

   ``` haskell
   act mempty a = a
   act (m1 <> m2) a = act m1 (act m2 a)
   ```

   That is, the action respects the operations defined by the `Monoid` class.

   For example, the natural numbers form a monoid under multiplication:

   ``` haskell
   newtype Multiply = Multiply Int

   instance semigroupMultiply :: Semigroup Multiply where
     append (Multiply n) (Multiply m) = Multiply (n * m)
	
   instance monoidMultiply :: Monoid Multiply where
     mempty = Multiply 1
   ```

   This monoid acts on strings by repeating an input string some number of
   times. Write an instance which implements this action.

   ``` haskell
   instance repeatAction :: Action Multiply String
   ```

   Does this instance satisfy the laws listed above?

``` haskell
instance repeatAction :: Action Multiply String where
  act (Multiply n) s = fromMaybe "" $ repeat n s
```

Yeah, they seem to satisfy the laws listed above.

``` haskell
> a = "foo"
> m1 = Multiply 2
> m2 = Multiply 3

> eq a $ act (mempty :: Multiply) a
true

> eq (act (m1 <> m2) a) $ act m1 (act m2 a)
true
```

3. (Medium) Write an instance `Action m a => Action m (Array a)`, where the
   action on arrays is defined by acting on each array element independently.

``` haskell
instance arrayAction :: Action m a => Action m (Array a) where
  act m f = act m <$> f
```

Arrrrrgh, I initially forgot to include the `Action m a` instance dependency.
For the longest time, I couldn't figure out why Haskell couldn't infer the type
of `act m`. T.T

4. (Difficult) Given the following newtype, write an instance for `Action m
   (Self m)`, where the monoid `m` acts on itself using `append`:

   ``` haskell
   newtype Self m = Self m
   ```

``` haskell
instance selfAction :: Monoid m => Action m (Self m) where
  act a (Self b) = Self (a <> b)
```

I had some trouble trying to understand why the `Monoid m` type constraint was
needed on the instance, so I went to the #purescript channel on the FP Slack to
ask for some help:

![typeclass-question](https://user-images.githubusercontent.com/40926021/66531865-2c578900-eac2-11e9-8247-93d6f50ff196.PNG)

5. (Difficult) Should the arguments of the multi-parameter type class `Action`
   be related by some functional dependency? Why or why not?

The functional dependency `m -> a` won't work because `m` is quantified in
`arrayAction`, making it overlap with `repeatAction`. It may make sense to
relate `a -> m` if the type `a` can uniquely identify type `m`, but it's hard
to tell if it does with only two instances. But if we do have the functional
dependency `a -> m`, we can write expressions like `act mempty "foo"` without
needing to type annotate `mempty`.

## Hashable Type Class

1. (Easy) Use PSCi to test the hash functions for each of the defined instances.

``` haskell
> hash 7
(HashCode 7)

> hash 100000
(HashCode 34465)

> hash true
(HashCode 1)

> hash false
(HashCode 0)

> hash 'n'
(HashCode 110)

> hash '7'
(HashCode 55)

> hash 'β'
(HashCode 946)

> hash ['n', 'u', 't', 't', 'y', '7', 't']
(HashCode 17544)
```

2. (Medium) Use the `hashEqual` function to write a function which tests if an
   array has any duplicate elements, using hash-equality as an approximation to
   value equality. Remember to check for value equality using `==` if a
   duplicate pair is found. *Hint*: the `nubBy` function in `Data.Array` should
   make this task much simpler.

``` haskell
hasDuplicate :: forall a. Hashable a => Array a -> Boolean
hasDuplicate xs = (length xs) /= (length $ nubByEq equal xs)
  where
    equal :: a -> a -> Boolean
    equal x y = (hashEqual x y) && (x == y)
```

3. (Medium) Write a `Hashable` instance for the following newtype which
   satisfies the type class law:

   ``` haskell
   newtype Hour = Hour Int

   instance eqHour :: Eq Hour where
     eq (Hour n) (Hour m) = mod n 12 == mod m 12
   ```

   The newtype `Hour` and its `Eq` instance represent the type of integers
   modulo 12, so that 1 and 13 are identified as equal, for example. Prove that
   the type class law holds for your instance.

``` haskell
instance hashHour :: Hashable Hour where
  hash (Hour n) = hashCode $ mod n 12
```

The type class law holds because I defined the `hash` function to equal the
wrapper integer modulo 12. lol, is this even a proof? how do you proof?

4. (Difficult) Prove the type class laws for the `Hashable` instances for
   `Maybe`, `Either`, and `Tuple`.

##### Maybe

Proof by exhaustion.

Case 1: The only value that represents an empty value (null) is `Nothing`.

Case 2: All other values are *just* wrapped values. The type class law holds
for this case because `hash` is defined as a function of the wrapped value.
$\text{Just} (a) = \text{Just} (b) \implies a = b \implies f(a) = f(b)$.

##### Either

Proof by exhaustion.

Case 1. `Left a` wraps `a`. The type class law holds for this case because
`hash` is defined as a function of the wrapped value.

Case 2. Ditto.

##### Tuple

$\text{Tuple} (a, b) = \text{Tuple} (c, d) \implies a = c \land b = d \implies
f(a, b) = f(c, d)$.

