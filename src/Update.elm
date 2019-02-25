module Update exposing (update)

import List exposing (filter, map)
import List.Extra exposing (elemIndex, getAt)
import Model exposing (stepAt)
import Phases.Configuration
import Phases.Dawn
import Phases.Day
import Phases.FirstNight
import Phases.Night
import Random
import Types exposing (Action(..), Model, Msg(..), Phase(..), State, Step(..))
import UndoList exposing (UndoList)
import Util exposing (unwrapPhase)
import Uuid exposing (uuidGenerator)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Undo ->
            ( UndoList.undo model, Cmd.none )

        Redo ->
            ( UndoList.redo model, Cmd.none )

        Action action ->
            ( UndoList.new (updateState action model.present) model, Cmd.none )


updateState : Action -> State -> State
updateState action state =
    let
        ( uuid, seed ) =
            Random.step uuidGenerator state.seed

        (Phase currentPhase) =
            state.currentPhase

        ( nextPhase, nextStep ) =
            getNextStep state
    in
    case action of
        SetNewPlayerName name ->
            { state | newPlayerName = name }

        AddPlayer ->
            { state | players = state.players ++ [ { id = uuid, name = state.newPlayerName } ], newPlayerName = "", seed = seed }

        RemovePlayer id ->
            { state | players = filter (\player -> player.id /= id) state.players }

        StepForward ->
            { state | currentPhase = nextPhase, currentStep = nextStep }


getNextStep : State -> ( Phase, Step )
getNextStep state =
    let
        (Phase currentPhase) =
            state.currentPhase

        stepsInPhase =
            currentPhase.steps state

        currentStepIndex =
            case elemIndex state.currentStep stepsInPhase of
                Just index ->
                    index

                Nothing ->
                    -- should not happen
                    -1

        nextStepInPhase =
            getAt (currentStepIndex + 1) stepsInPhase

        nextPhase =
            getNextPhase currentPhase
    in
    case nextStepInPhase of
        Just step ->
            ( state.currentPhase, step )

        Nothing ->
            ( Phase nextPhase, nextPhase.steps state |> stepAt 0 )


getNextPhase phase =
    let
        configuration =
            unwrapPhase Phases.Configuration.configuration

        firstNight =
            unwrapPhase Phases.FirstNight.firstNight

        dawn =
            unwrapPhase Phases.Dawn.dawn

        day =
            unwrapPhase Phases.Day.day

        night =
            unwrapPhase Phases.Night.night
    in
    if phase == configuration then
        firstNight

    else if phase == firstNight then
        dawn

    else if phase == dawn then
        day

    else if phase == day then
        night

    else if phase == night then
        dawn

    else
        phase
