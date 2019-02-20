module Update exposing (update)

import List exposing (filter, map)
import List.Extra exposing (elemIndex, getAt)
import Model exposing (stepAt)
import Random
import Types exposing (Action(..), Model, Msg(..), Phase(..), State, Step(..))
import UndoList exposing (UndoList)
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

        (Step currentStep) =
            state.currentStep
    in
    case action of
        SetNewPlayerName name ->
            { state | newPlayerName = name }

        AddPlayer ->
            { state | players = state.players ++ [ { id = uuid, name = state.newPlayerName } ], newPlayerName = "", seed = seed }

        RemovePlayer id ->
            { state | players = filter (\player -> player.id /= id) state.players }

        StepForward ->
            { state | currentStep = nextStep state }


nextStep : State -> Step
nextStep state =
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

        (Phase nextPhase) =
            currentPhase.nextPhase state
    in
    case nextStepInPhase of
        Just step ->
            step

        Nothing ->
            nextPhase.steps state |> stepAt 0
