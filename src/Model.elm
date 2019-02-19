module Model exposing (Flags, Model, State, init)

import Msg exposing (Msg)
import Random
import UndoList exposing (UndoList)
import Uuid exposing (Uuid)


type alias Model =
    UndoList State


type alias State =
    { players : List Player
    , newPlayerName : String
    , seed : Random.Seed
    }


type alias Player =
    { id : Uuid
    , name : String
    }


type alias Flags =
    { seed : Int }


initState : Flags -> State
initState flags =
    { players = [], newPlayerName = "", seed = Random.initialSeed flags.seed }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( UndoList.fresh <| initState flags, Cmd.none )
