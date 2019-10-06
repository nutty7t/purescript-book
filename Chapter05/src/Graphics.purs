module Graphics where

import Prelude

import Data.Maybe (Maybe(..))

data Shape
  = Circle Point Number
  | Rectangle Point Number Number
  | Line Point Point
  | Text Point String

data Point = Point
  { x :: Number
  , y :: Number
  }

showPoint :: Point -> String
showPoint (Point { x: x, y: y }) =
  "(" <> show x <> ", " <> show y <> ")"

-- | Exercise 1
circle :: Shape
circle = Circle p 10.0
  where
    p :: Point
    p = Point { x: 0.0, y: 0.0 }

-- | Exercise 2
origin :: Point
origin = Point { x: 0.0, y: 0.0 }

dilate :: Number -> Point -> Point
dilate f (Point { x, y }) = Point { x: (x * f), y: (y * f) }

scale2 :: Shape -> Shape
scale2 (Circle c r) = Circle origin (r * 2.0)
scale2 (Rectangle c w h) = Rectangle origin (w * 2.0) (h * 2.0)
scale2 (Line start end) = Line (dilate 2.0 start) (dilate 2.0 end)
scale2 (Text p text) = Text origin text

-- | Exercise 3
extractText :: Shape -> Maybe String
extractText (Text p text) = Just text
extractText _ = Nothing

