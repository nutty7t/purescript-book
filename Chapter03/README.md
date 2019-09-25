# Chapter 3

1. (Easy) Test your understanding of the `findEntry` function by writing down
   the types of each of its major subexpressions. For example, the type of the
   `head` function as used is specialized to `AddressBook -> Maybe Entry`.

``` haskell
head :: AddressBook -> Maybe Entry
filter :: (Entry -> Boolean) -> AddressBook -> AddressBook
filterEntry :: Entry -> Boolean

(filter filterEntry) :: AddressBook -> AddressBook
(head <<< filter filterEntry) :: AddressBook -> Maybe Entry

findEntry :: String -> String -> AddressBook -> Maybe Entry
```

2. (Medium) Write a function which looks up an `Entry` given a street address,
   by reusing the existing code in `findEntry`. Test your function in PSCi.

``` haskell
findEntry2 :: Address -> AddressBook -> Maybe Entry
findEntry2 address = head <<< filter filterEntry
  where
    filterEntry :: Entry -> Boolean
    filterEntry entry = entry.address == address
```

3. (Medium) Write a function which tests whether a name appears in an
   `AddressBook`, returning a Boolean value. *Hint*: Use PSCi to find the type
   of the `Data.List.null` function, which test whether a list is empty or not.

``` haskell
exists :: String -> String -> AddressBook -> Boolean
exists firstName lastName = not <<< null <<< filter filterEntry
  where
    filterEntry :: Entry -> Boolean
    filterEntry entry = entry.firstName == firstName && entry.lastName == lastName

-- | We can also implement 'exists' in terms of 'findEntry'.
exists2 :: String -> String -> AddressBook -> Boolean
exists2 firstName lastName = isJust <<< findEntry firstName lastName
```

4. (Difficult) Write a function `removeDuplicates` which removes duplicate
   address book entries with the same first and last names. *Hint*: Use PSCi to
   find the type of the `Data.List.nubBy` function, which removes duplicate
   elements from a list based on an equality predicate.

> "nub" is such a cute word. (ᅌᴗᅌ* )

``` haskell
removeDuplicates :: AddressBook -> AddressBook
removeDuplicates book = nubBy nubEntry book
  where
    nubEntry :: Entry -> Entry -> Boolean
    nubEntry e1 e2 = e1.firstName == e2.firstName &&
                     e1.lastName == e2.lastName
```
