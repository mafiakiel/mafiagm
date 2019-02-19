module Model exposing (Model, State, init)

import Msg exposing (Msg)
import UndoList exposing (UndoList)


type alias Model =
    UndoList State


type alias State =
    { players : List Player
    , newPlayerName : String
    }


type alias Player =
    { name : String
    }


initState : State
initState =
    { players = [], newPlayerName = "" }


init : ( Model, Cmd Msg )
init =
    ( UndoList.fresh initState, Cmd.none )
