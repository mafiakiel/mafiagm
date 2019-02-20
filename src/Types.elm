module Types exposing (Action(..), Flags, Model, Msg(..), Player, State)

-- All types are defined here in a central file because Elm doesn't allow circular file dependencies.

import Html exposing (Html)
import Random
import UndoList exposing (UndoList)
import Uuid exposing (Uuid)



-- Model


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



-- Msg


type Action
    = SetNewPlayerName String
    | AddPlayer
    | RemovePlayer Uuid


type Msg
    = Undo
    | Redo
    | Action Action
