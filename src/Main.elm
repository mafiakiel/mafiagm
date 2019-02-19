module App exposing (main)

import Browser
import Model exposing (initialModel)
import Update exposing (update)
import View exposing (view)


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
