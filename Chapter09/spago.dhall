{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "my-project"
, dependencies =
    [ "arrays"
    , "canvas"
    , "console"
    , "effect"
    , "integers"
    , "math"
    , "maybe"
    , "partial"
    , "psci-support"
    , "random"
    , "refs"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
