module Graph where

import Prelude

import Data.Array (foldM, (..))
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (error)
import Graphics.Canvas (Context2D, closePath, fillPath, getCanvasElementById, getContext2D, lineTo, setFillStyle, setStrokeStyle, stroke)
import Partial.Unsafe (unsafePartial)

type Point = { x :: Number, y :: Number }

renderPath :: Context2D -> Array Point -> Effect Unit
renderPath ctx xs = do
  setFillStyle ctx "#FF0000"
  setStrokeStyle ctx "#000000"
  fillPath ctx $ do
    foldM (\_ p -> lineTo ctx p.x p.y) unit xs
    closePath ctx
  stroke ctx

-- | some parabola
f :: Number -> Point
f n =
  { x : 300.0 + 200.0 * n
  , y : 700.0 * n * n
  }

main :: Effect Unit
main = void $ unsafePartial do
  element <- getCanvasElementById "canvas"
  case element of
    Nothing -> error "canvas element not found"
    Just canvas -> do
      ctx <- getContext2D canvas
      renderPath ctx $ -100 .. 100 <#> toNumber <#> flip div 100.0 <#> f

