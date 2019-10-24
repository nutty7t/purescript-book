module Example.Shapes where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Graphics.Canvas (arc, closePath, fillPath, getCanvasElementById, getContext2D, lineTo, moveTo, rect, setFillStyle, setStrokeStyle, stroke, strokePath)
import Math as Math
import Partial.Unsafe (unsafePartial)

translate
  :: forall r
   . Number
  -> Number
  -> { x :: Number, y :: Number | r }
  -> { x :: Number, y :: Number | r }
translate dx dy shape = shape
  { x = shape.x + dx
  , y = shape.y + dy
  }

main :: Effect Unit
main = void $ unsafePartial do
  Just canvas <- getCanvasElementById "canvas"
  ctx <- getContext2D canvas

  _ <- setFillStyle ctx "#BBBBBB"
  _ <- setStrokeStyle ctx "#FFFF00"

  _ <- fillPath ctx $ rect ctx $ translate (-200.0) (-200.0)
    { x: 250.0
    , y: 250.0
    , width: 100.0
    , height: 100.0
    }

  _ <- stroke ctx
  _ <- setFillStyle ctx "#00FF00"
  _ <- setStrokeStyle ctx "#FF0000"

  _ <- fillPath ctx $ arc ctx $ translate 200.0 200.0
    { x: 300.0
    , y: 300.0
    , radius: 50.0
    , start: Math.pi * 5.0 / 8.0
    , end: Math.pi * 2.0
    }

  _ <- stroke ctx
  _ <- setFillStyle ctx "#FF0000"
  _ <- setStrokeStyle ctx "#000000"

  strokePath ctx $ do
    _ <- moveTo ctx 300.0 260.0
    _ <- lineTo ctx 260.0 340.0
    _ <- lineTo ctx 340.0 340.0
    _ <- lineTo ctx 390.0 260.0
    closePath ctx

