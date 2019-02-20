module Model exposing (init, stepAt)

import Html exposing (Html, text)
import List.Extra exposing (getAt)
import Phases.Configuration exposing (configurationPhase, rules)
import Random
import Types exposing (Action, Flags, Model, Msg, State, Step(..))
import UndoList exposing (UndoList)
import Uuid exposing (Uuid)


stepError : Step
stepError =
    Step
        { name = "Error"
        , view = \_ -> text "Step not found"
        }


stepAt : Int -> List Step -> Step
stepAt index steps =
    case getAt index steps of
        Just step ->
            step

        Nothing ->
            stepError


initState : Flags -> State
initState flags =
    { players = [], newPlayerName = "", seed = Random.initialSeed flags.seed, currentPhase = configurationPhase, currentStep = rules }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( UndoList.fresh <| initState flags, Cmd.none )
