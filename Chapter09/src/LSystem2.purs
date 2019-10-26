module LSystem2 where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (error, logShow)
import Effect.Random (random)
import Example.LSystem (applyProductions, interpretString)
import Graphics.Canvas (getCanvasElementById, getContext2D, lineTo, setShadowBlur, setShadowColor, setShadowOffsetX, setShadowOffsetY, setStrokeStyle, strokePath)
import Math (cos, pi, sin)

data Alphabet = L | R | F Boolean

type Sentence = Array Alphabet

type State =
  { x :: Number
  , y :: Number
  , theta :: Number
  }

main :: Effect Unit
main = do
  element <- getCanvasElementById "canvas"
  case element of
    Nothing -> error "canvas element not found"
    Just canvas -> void $ do
      ctx <- getContext2D canvas

      let
        -- | Exercise 6
        initial :: Sentence
        initial = [F false]

        productions :: Alphabet -> Sentence
        productions L = [L]
        productions R = [R]
        productions (F false) = [F false, L, F true, L, F false, R, F true, R, F false, R, F true, R, F false, L, F true, L, F false]
        productions (F true) = [F true, R, F false, R, F true, L, F false, L, F true, L, F false, L, F true, R, F false, R, F true]

        interpret :: State -> Alphabet -> Effect State
        interpret state L = pure $ state { theta = state.theta - (pi / 3.0) }
        interpret state R = pure $ state { theta = state.theta + (pi / 3.0) }
        interpret state (F _) = do
          -- | Exercise 7
          r <- random
          let
            x = state.x + cos state.theta * 20.0 * r
            y = state.x + sin state.theta * 20.0 * r
          lineTo ctx x y
          logShow state
          pure { x, y, theta: state.theta }

        initialState :: State
        initialState = { x: 0.0, y: 0.0, theta: 0.0 }

      setShadowOffsetX ctx 5.0
      setShadowOffsetY ctx 5.0
      setShadowBlur ctx 5.0
      setShadowColor ctx "#0000FF"

      _ <- setStrokeStyle ctx "#FFFFFF"
      strokePath ctx $ interpretString interpret initialState $ applyProductions initial productions 3

