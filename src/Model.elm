module Model exposing (init)

import Bootstrap.Tab as Tab
import Html exposing (Html, text)
import List.Extra exposing (getAt)
import Phases.Abstract exposing (abstractStep)
import Phases.Configuration exposing (configuration)
import Random
import Types exposing (Action, Flags, Model, Msg, State, Step(..))
import UndoList exposing (UndoList)
import Uuid exposing (Uuid)


initState : Flags -> State
initState flags =
    { players = []
    , newPlayerName = ""
    , seed = Random.initialSeed flags.seed
    , currentPhase = configuration
    , currentStepIndex = 0
    , pool = []
    , selectedCardCategory = Tab.initialState
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( UndoList.fresh <| initState flags, Cmd.none )
