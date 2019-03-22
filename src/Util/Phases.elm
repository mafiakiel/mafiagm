module Util.Phases exposing
    ( combineStepModes
    , getCurrentStep
    , stepAt
    , stepError
    , stepModeByParty
    , stepModeByPartyAndRole
    , stepModeByRole
    , unwrapPhase
    , unwrapStep
    )

import Html exposing (text)
import List exposing (any, filter, map, member)
import List.Extra exposing (getAt)
import Types exposing (Party, Phase(..), Role, State, Step(..), StepMode(..))
import Util.Misc exposing (apply)
import Util.Player exposing (isAlive)


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
        { init = identity
        , cleanup = identity
        , stepForwardVeto = always Nothing
        , playerControls = []
        , isPlayerActive = always <| always False
        , name = "Error"
        , view = always <| text "Step not found"
        , mode = always Execute
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


stepModeByRole : Role -> State -> StepMode
stepModeByRole role state =
    let
        playerRoles =
            state.players
                |> filter isAlive
                |> map (\player -> player.role)

        fakeRoles =
            map (\card -> card.role) state.fakePool
    in
    if member role playerRoles then
        Execute

    else if member role fakeRoles then
        Fake

    else
        Skip


stepModeByParty : Party -> State -> StepMode
stepModeByParty party state =
    let
        playerParties =
            state.players
                |> filter isAlive
                |> map (\player -> player.party)

        fakeParties =
            map (\card -> card.party) state.fakePool
    in
    if member party playerParties then
        Execute

    else if member party fakeParties then
        Fake

    else
        Skip


stepModeByPartyAndRole : Party -> Role -> State -> StepMode
stepModeByPartyAndRole party role state =
    let
        match playerOrCard =
            playerOrCard.party == party && playerOrCard.role == role
    in
    if any match state.players then
        Execute

    else if any match state.fakePool then
        Fake

    else
        Skip


combineStepModes : List (State -> StepMode) -> State -> StepMode
combineStepModes modeProviders state =
    let
        modes =
            map (apply state) modeProviders
    in
    if member Execute modes then
        Execute

    else if member Fake modes then
        Fake

    else
        Skip
