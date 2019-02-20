module Model exposing (init)

import Html exposing (Html)
import Random
import Types exposing (Action, Flags, Model, Msg, State)
import UndoList exposing (UndoList)
import Uuid exposing (Uuid)


initState : Flags -> State
initState flags =
    { players = [], newPlayerName = "", seed = Random.initialSeed flags.seed }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( UndoList.fresh <| initState flags, Cmd.none )
