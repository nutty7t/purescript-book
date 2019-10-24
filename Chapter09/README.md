# Chapter 9

## Simple Shapes

1. (Easy) Experiment with the `strokePath` and `setStrokeStyle` functions in
   each of the examples so far.

``` sh
spago bundle-app --main Example.Shapes --to html/index.js
```

2. (Easy) The `fillPath` and `strokePath` functions can be used to render
   complex paths with a common style by using a do notation block inside the
   function argument. Try changing the `Rectangle` example to render two
   rectangles side-by-side using the same call to `fillPath`. Try rendering a
   sector of a circle by using a combination of a piecewise-linear path and an
   arc segment.

``` sh
spago bundle-app --main Example.Rectangle --to html/index.js
```

``` haskell
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
```

3. (Medium) Given the following record type:

   ``` haskell
   type Point = { x :: Number, y :: Number }
   ```

   which represents a 2D point, write a function `renderPath` which strokes a
   closed path constructed from a number of points:

   ``` haskell
   renderPath
     :: Context2D
     -> Array Point
     -> Effect Unit
   ```

   Given a function

   ``` haskell
   f :: Number -> Point
   ```

   which takes a `Number` between `0` and `1` as its argument and returns a
   `Point`, write an action which plots `f` by using your `renderPath`
   function. Your action should approximate the path by sampling `f` at a
   finite set of points.

   Experiment by rendering different paths by varying the function `f`.

``` sh
spago bundle-app --main Graph --to html/index.js
```

``` haskell
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
```

## Canvas

1. (Easy) Write a higher-order function which strokes and fills a path
   simultaneously. Rewrite the `Random.purs` example using your function.

``` sh
spago bundle-app --main Example.Random --to html/index.js
```

``` haskell
fillStrokePath :: forall a. Context2D -> Effect a -> Effect a
fillStrokePath ctx path = do
  _ <- fillPath ctx path -- not quite sure why we have to explicitly discard
  strokePath ctx path
```

2. (Medium) Use `Random` and `Dom` to create an application which renders a
   circle with random position, color and radius to the canvas when the mouse
   is clicked.

``` sh
spago bundle-app --main ClickCircle --to html/index.js
```

``` haskell
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
```

3. (Medium) Write a function which transforms the scene by rotating it around a
   point with specified coordinates. *Hint*: use a translation to first translate
   the scene to the origin.

I'm unsure which scene is being referred to.

