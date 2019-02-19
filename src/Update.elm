module Update exposing (Msg(..), update)

import Model exposing (Model)
import UndoList exposing (UndoList)


type Msg
    = Undo
    | Redo
    | Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        Undo ->
            UndoList.undo model

        Redo ->
            UndoList.redo model

        Increment ->
            UndoList.new (model.present + 1) model
