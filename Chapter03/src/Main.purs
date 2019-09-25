module AddressBook where

import Prelude

import Control.Plus (empty)
import Data.List (List(..), filter, head, nubBy, null)
import Data.Maybe (Maybe, isJust)

type Address =
  { street :: String
  , city   :: String
  , state  :: String
  }

type Entry =
  { firstName :: String
  , lastName  :: String
  , address   :: Address
  }

type AddressBook = List Entry

showAddress :: Address -> String
showAddress addr = addr.street <> ", " <> addr.city <> ", " <> addr.state

showEntry :: Entry -> String
showEntry entry = entry.lastName <> ", " <> entry.firstName <> ": " <> showAddress entry.address

emptyBook :: AddressBook
emptyBook = empty

insertEntry :: Entry -> AddressBook -> AddressBook
insertEntry = Cons

findEntry :: String -> String -> AddressBook -> Maybe Entry
findEntry firstName lastName = head <<< filter filterEntry
  where
    filterEntry :: Entry -> Boolean
    filterEntry entry = entry.firstName == firstName && entry.lastName == lastName

-- | Exercise 2
findEntry2 :: Address -> AddressBook -> Maybe Entry
findEntry2 address = head <<< filter filterEntry
  where
    filterEntry :: Entry -> Boolean
    filterEntry entry = entry.address == address
    -- filterEntry entry = entry.address.street == address.street &&
    --                     entry.address.city == address.city &&
    --                     entry.address.state == address.state

-- | Exercise 3
exists :: String -> String -> AddressBook -> Boolean
exists firstName lastName = not <<< null <<< filter filterEntry
  where
    filterEntry :: Entry -> Boolean
    filterEntry entry = entry.firstName == firstName && entry.lastName == lastName

-- | We can also implement 'exists' in terms of 'findEntry'.
exists2 :: String -> String -> AddressBook -> Boolean
exists2 firstName lastName = isJust <<< findEntry firstName lastName

-- | Exercise 4
removeDuplicates :: AddressBook -> AddressBook
removeDuplicates book = nubBy nubEntry book
  where
    nubEntry :: Entry -> Entry -> Boolean
    nubEntry e1 e2 = e1.firstName == e2.firstName &&
                     e1.lastName == e2.lastName

