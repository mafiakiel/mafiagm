module Types exposing (Action(..), Flags, Model, Msg(..), Phase(..), Player, State, Step(..))

-- All types are defined here in a central place because Elm doesn't allow circular file dependencies.

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
    , currentPhase : Phase
    , currentStep : Step
    }


type alias Player =
    { id : Uuid
    , name : String
    }


type Phase
    = Phase
        { name : String
        , steps : State -> List Step
        , nextPhase : State -> Phase
        }


type Step
    = Step
        { name : String
        , view : State -> Html Msg
        }


type alias Flags =
    { seed : Int }


type alias UpdateState =
    Action -> State -> State



-- Msg


type Action
    = SetNewPlayerName String
    | AddPlayer
    | RemovePlayer Uuid
    | StepForward


type Msg
    = Undo
    | Redo
    | Action Action
