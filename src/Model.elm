module Model exposing (Model, State, init)

import Random
import Msg exposing (Msg)
import UndoList exposing (UndoList)
import Uuid exposing (Uuid)


type alias Model =
    UndoList State


type alias State =
    { players : List Player
    , newPlayerName : String, seed : Random.Seed
    }


type alias Player =
    { id: Uuid, name : String
    }


initState : State
initState =
    { players = [], newPlayerName = "", seed = Random.initialSeed 0 }


init : ( Model, Cmd Msg )
init =
    ( UndoList.fresh initState, Cmd.none )
