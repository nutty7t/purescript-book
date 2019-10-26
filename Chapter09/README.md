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

## L-Systems

1. (Easy) Modify the L-system example above to use `fillPath` instead of
   `strokePath`. *Hint*: you will need to include a call to `closePath`, and
   move the call to `moveTo` outside of the `interpret` function.

``` sh
spago bundle-app --main Example.LSystem --to html/index.js
```

2. (Easy) Try changing the various numerical constants in the code, to
   understand their effect on the rendered system.

``` sh
spago bundle-app --main Example.LSystem --to html/index.js
```

3. (Medium) Break the `lsystem` function into two smaller functions. The first
   should build the final sentence using repeated application of `concatMap`,
   and the second should use `foldM` to interpret the result.

``` haskell
applyProductions :: forall a. Array a -> (a -> Array a) -> Int -> Array a
applyProductions str prod 0 = str
applyProductions str prod n = applyProductions (concatMap prod str) prod (n - 1)

interpretString :: forall a m s. Monad m => (s -> a -> m s) -> s -> Array a -> m s
interpretString interpret state str = foldM interpret state str
```

4. (Medium) Add a drop shadow to the filled shape, by using the
   `setShadowOffsetX`, `setShadowOffsetY`, `setShadowBlur` and `setShadowColor`
   actions. *Hint*: use PSCi to find the types of these functions.

``` sh
spago bundle-app --main Example.LSystem --to html/index.js
```

``` haskell
setShadowOffsetX ctx 5.0
setShadowOffsetY ctx 5.0
setShadowBlur ctx 5.0
setShadowColor ctx "#0000FF"
```

5. (Medium) The angle of the corners is currently a constant (`pi/3`). Instead,
   it can be moved into the `Alphabet` data type, which allows it to be changed
   by the production rules:

   ``` haskell
   type Angle = Number
   
   data Alphabet = L Angle | R Angle | F
   ```

   How can this new information be used in the production rules to create
   interesting shapes?

``` sh
spago bundle-app --main Example.LSystem --to html/index.js
```

6. (Difficult) An L-system is given by an alphabet with four letters: `L` (turn
   left through 60 degrees), `R` (turn right through 60 degrees), `F` (move
   forward) and `M` (also move forward).

   The initial sentence of the system is the single letter `M`.

   The production rules are specified as follows:

   ```
   L -> L
   R -> R
   F -> FLMLFRMRFRMRFLMLF
   M -> MRFRMLFLMLFLMRFRM
   ```

   Render this L-system. *Note*: you will need to decrease the number of
   iterations of the production rules, since the size of the final sentence
   grows exponentially with the number of iterations.

   Now, notice the symmetry between `L` and `M` in the production rules. The
   two "move forward" instructions can be differentiated using a `Boolean`
   value using the following alphabet type:

   ``` haskell
   data Alphabet = L | R | F Boolean
   ```

   Implement this L-system again using this representation of the alphabet.

``` sh
spago bundle-app --main LSystem2 --to html/index.js
```

``` haskell
let
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
    let
  	  x = state.x + cos state.theta * 10.0
  	  y = state.x + sin state.theta * 10.0
    _ <- lineTo ctx x y
    pure { x, y, theta: state.theta }

  initialState :: State
  initialState = { x: 0.0, y: 0.0, theta: 0.0 }
```

7. (Difficult) Use a different monad `m` in the interpretation function. You
   might try using `Effect.Console` to write the L-system onto the console, or
   using `Effect.Random` to apply random "mutations" to the state type.

``` sh
spago bundle-app --main LSystem2 --to html/index.js
```

``` haskell
interpret :: State -> Alphabet -> Effect State
interpret state L = pure $ state { theta = state.theta - (pi / 3.0) }
interpret state R = pure $ state { theta = state.theta + (pi / 3.0) }
interpret state (F _) = do
  r <- random
  let
    x = state.x + cos state.theta * 20.0 * r
    y = state.x + sin state.theta * 20.0 * r
  lineTo ctx x y
  logShow state
  pure { x, y, theta: state.theta }
```

