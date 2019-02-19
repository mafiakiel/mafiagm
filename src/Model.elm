module Model exposing (Model, State, initialModel)

import UndoList exposing (UndoList)


type alias Model =
    UndoList State


type alias State =
    Int


initialModel : Model
initialModel =
    UndoList.fresh 0
