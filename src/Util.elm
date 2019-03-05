module Util exposing
    ( getCurrentStep
    , isInChurch
    , stepAt
    , stepError
    , stepModeByParty
    , stepModeByRole
    , unwrapPhase
    , unwrapStep
    )

import Html exposing (text)
import List exposing (map, member)
import List.Extra exposing (getAt)
import Types exposing (Marker(..), Party(..), Phase(..), Player, Role(..), State, Step(..), StepMode(..))


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
        , mode = \_ -> Execute
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


isInChurch : Player -> Bool
isInChurch player =
    member Converted player.markers
        || player.role
        == Pope
        || player.role
        == Monk
        || player.role
        == MonkInLove


stepModeByRole : Role -> State -> StepMode
stepModeByRole role state =
    let
        playerRoles =
            map (\player -> player.role) state.players

        poolRoles =
            map (\card -> card.role) state.pool
    in
    if member role playerRoles then
        Execute

    else if member role poolRoles then
        Fake

    else
        Skip


stepModeByParty : Party -> State -> StepMode
stepModeByParty party state =
    let
        playerParties =
            map (\player -> player.party) state.players

        poolParties =
            map (\card -> card.party) state.pool
    in
    if member party playerParties then
        Execute

    else if member party poolParties then
        Fake

    else
        Skip
