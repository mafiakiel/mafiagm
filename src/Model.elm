module Model exposing (init)

import Bootstrap.Tab as Tab
import Phases.Configuration exposing (configuration)
import Random
import Types exposing (Action, Flags, Model, Msg, State, Step(..))
import UndoList exposing (UndoList)


initState : Flags -> State
initState flags =
    { players = []
    , newPlayerName = ""
    , seed = Random.initialSeed flags.seed
    , currentPhase = configuration
    , currentStepIndex = 0
    , pool = []
    , selectedCardCategory = Tab.initialState
    , undealtPool = []
    , nextNominationPosition = 1
    , stealthMode = False
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( UndoList.fresh <| initState flags, Cmd.none )
