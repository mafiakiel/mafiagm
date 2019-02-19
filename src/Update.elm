module Update exposing (update)

import Model exposing (Model)
import Msg exposing (Msg(..))
import UndoList exposing (UndoList)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Undo ->
            ( UndoList.undo model, Cmd.none )

        Redo ->
            ( UndoList.redo model, Cmd.none )

        Increment ->
            ( UndoList.new (model.present + 1) model, Cmd.none )
