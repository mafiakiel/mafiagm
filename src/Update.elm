module Update exposing (update)

import List exposing (filter)
import Random
import Types exposing (Action(..), Model, Msg(..), State)
import UndoList exposing (UndoList)
import Uuid exposing (uuidGenerator)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Undo ->
            ( UndoList.undo model, Cmd.none )

        Redo ->
            ( UndoList.redo model, Cmd.none )

        Action action ->
            ( UndoList.new (updateState action model.present) model, Cmd.none )


updateState : Action -> State -> State
updateState action state =
    let
        ( uuid, seed ) =
            Random.step uuidGenerator state.seed
    in
    case action of
        SetNewPlayerName name ->
            { state | newPlayerName = name }

        AddPlayer ->
            { state | players = state.players ++ [ { id = uuid, name = state.newPlayerName } ], newPlayerName = "", seed = seed }

        RemovePlayer id ->
            { state | players = filter (\player -> player.id /= id) state.players }
