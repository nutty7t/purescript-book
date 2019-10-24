module ClickCircle where

import Prelude

import Data.Foldable (for_)
import Data.Int (floor, hexadecimal, toStringAs)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (logShow)
import Effect.Console (error)
import Effect.DOM (addEventListener, querySelector)
import Effect.Random (random)
import Graphics.Canvas (Context2D, arc, fillPath, getCanvasElementById, getContext2D, setFillStyle, setStrokeStyle, strokePath)
import Math (pi)

fillStrokePath :: forall a. Context2D -> Effect a -> Effect a
fillStrokePath ctx path = do
  _ <- fillPath ctx path
  strokePath ctx path

drawRandomCircle :: Context2D -> Effect Unit
drawRandomCircle ctx = do
  x <- random
  y <- random
  r <- random
  c <- random

  -- | Not a uniform distribution because the numbers are not zero padded,
  -- | but they are still random colors.
  let color = append "#" $ toStringAs hexadecimal $ floor $ c * 16777215.0 -- 0xFFFFFF
  let path = arc ctx
       { x      : x * 600.0
       , y      : y * 600.0
       , radius : r * 50.0
       , start  : 0.0
       , end    : 2.0 * pi
       }

  setFillStyle ctx color
  setStrokeStyle ctx "#000000"
  fillStrokePath ctx path

main :: Effect Unit
main = do
  element <- getCanvasElementById "canvas"
  case element of
    Nothing -> error "canvas element not found"
    Just canvas -> do
      ctx <- getContext2D canvas
      node <- querySelector "#canvas"
      for_ node $ addEventListener "click" $ void do
        logShow "Mouse clicked!"
        drawRandomCircle ctx

