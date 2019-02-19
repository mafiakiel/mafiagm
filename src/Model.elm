module Model exposing (Model, State, init)

import Msg exposing (Msg)
import UndoList exposing (UndoList)


type alias Model =
    UndoList State


type alias State =
    Int


init : ( Model, Cmd Msg )
init =
    ( UndoList.fresh 0, Cmd.none )
