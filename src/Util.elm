module Util exposing (getCurrentStep, stepAt, stepError, unwrapPhase, unwrapStep)

import Html exposing (text)
import List.Extra exposing (getAt)
import Types exposing (Phase(..), Step(..))


unwrapPhase wrapped =
    let
        (Phase unwrapped) =
            wrapped
    in
    unwrapped


unwrapStep wrapped =
    let
        (Step unwrapped) =
            wrapped
    in
    unwrapped


stepError : Step
stepError =
    Step
        { init = \state -> state
        , stepForwardVeto = \_ -> Nothing
        , playerControls = []
        , isPlayerActive = \_ _ -> False
        , name = "Error"
        , view = \_ -> text "Step not found"
        }


stepAt : List Step -> Int -> Step
stepAt steps index =
    case getAt index steps of
        Just step ->
            step

        Nothing ->
            stepError


getCurrentStep state =
    stepAt (unwrapPhase state.currentPhase).steps state.currentStepIndex |> unwrapStep
