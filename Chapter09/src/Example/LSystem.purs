module Example.LSystem where

import Prelude

import Data.Array (concatMap, foldM)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Graphics.Canvas (fillPath, getCanvasElementById, getContext2D, lineTo, setFillStyle, setShadowBlur, setShadowColor, setShadowOffsetX, setShadowOffsetY)
import Math (pi)
import Math as Math
import Partial.Unsafe (unsafePartial)

lsystem :: forall a m s. Monad m => Array a -> (a -> Array a) -> (s -> a -> m s) -> Int -> s -> m s
lsystem init prod interpret 0 state = foldM interpret state init
lsystem init prod interpret n state = lsystem (concatMap prod init) prod interpret (n - 1) state

-- | Exercise 3
applyProductions :: forall a. Array a -> (a -> Array a) -> Int -> Array a
applyProductions str prod 0 = str
applyProductions str prod n = applyProductions (concatMap prod str) prod (n - 1)

interpretString :: forall a m s. Monad m => (s -> a -> m s) -> s -> Array a -> m s
interpretString interpret state str = foldM interpret state str

-- | Exercise 5
type Angle = Number

data Alphabet = L Angle | R Angle | F

type Sentence = Array Alphabet

type State =
  { x :: Number
  , y :: Number
  , theta :: Number
  }

main :: Effect Unit
main = void $ unsafePartial do
  Just canvas <- getCanvasElementById "canvas"
  ctx <- getContext2D canvas

  let
    corner :: Number
    corner = pi / 3.0

    initial :: Sentence
    initial = [F, R corner, R corner, F, R corner, R corner, F, R corner, R corner]

    productions :: Alphabet -> Sentence
    productions (L angle) = [L angle]
    productions (R angle) = [R angle]
    productions F = [F, L corner, F, R corner, R corner, F, L corner, F]

    interpret :: State -> Alphabet -> Effect State
    interpret state (L angle) = pure $ state { theta = state.theta - angle }
    interpret state (R angle) = pure $ state { theta = state.theta + angle }
    interpret state F = do
      let x = state.x + Math.cos state.theta * 1.5
          y = state.y + Math.sin state.theta * 2.0 -- | Exercise 2
      _ <- lineTo ctx x y
      pure { x, y, theta: state.theta }

    initialState :: State
    initialState = { x: 120.0, y: 160.0, theta: 0.0 }

  -- | Exercise 4
  setShadowOffsetX ctx 5.0
  setShadowOffsetY ctx 5.0
  setShadowBlur ctx 5.0
  setShadowColor ctx "#0000FF"

  -- | Exercise 1
  _ <- setFillStyle ctx "#000000"
  fillPath ctx $ interpretString interpret initialState $ applyProductions initial productions 5
