module Main where

import Prelude

import Effect (Effect)
import Effect.Alert (alert, confirm)

main :: Effect Unit
main = do
  -- | Exercise 1
  alert "It works! FFI works!"
  result <- confirm "Do you trust me?"
  if result
    then alert "Then Jump!"
    else alert "T.T"

