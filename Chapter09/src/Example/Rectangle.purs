module Example.Rectangle where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Graphics.Canvas (arc, closePath, fillPath, getCanvasElementById, getContext2D, lineTo, moveTo, setFillStyle)
import Math (pi)
import Partial.Unsafe (unsafePartial)

main :: Effect Unit
main = void $ unsafePartial do
  Just canvas <- getCanvasElementById "canvas"
  ctx <- getContext2D canvas

  _ <- setFillStyle ctx "#0000FF"

  -- | Two rectangles
  fillPath ctx $ do
    moveTo ctx 100.0 100.0
    lineTo ctx 150.0 100.0
    lineTo ctx 150.0 150.0
    lineTo ctx 100.0 150.0
    closePath ctx

    moveTo ctx 200.0 100.0
    lineTo ctx 250.0 100.0
    lineTo ctx 250.0 150.0
    lineTo ctx 200.0 150.0
    closePath ctx

  -- | Sector of circle
  fillPath ctx $ arc ctx
    { x: 300.0
    , y: 300.0
    , radius: 100.0
    , start: 0.0
    , end: 0.5 * pi
    }

  fillPath ctx $ do
    moveTo ctx 300.0 300.0
    lineTo ctx 400.0 300.0
    lineTo ctx 300.0 400.0
    closePath ctx

