module Main exposing (main)

import Browser
import Model exposing (Flags, Model, init)
import Msg exposing (Msg)
import Update exposing (update)
import View exposing (view)


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
