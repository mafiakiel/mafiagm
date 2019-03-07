module Update exposing (update)

import List exposing (length)
import List.Extra exposing (filterNot, remove, updateIf)
import Phases.Configuration exposing (configuration)
import Phases.Dawn
import Phases.Day
import Phases.FirstNight
import Phases.Night
import Random
import Types
    exposing
        ( Action(..)
        , Marker(..)
        , Model
        , Msg(..)
        , Party(..)
        , Phase(..)
        , Role(..)
        , State
        , Step(..)
        , StepMode(..)
        )
import UndoList exposing (UndoList)
import Util exposing (stepAt, unwrapPhase, unwrapStep)
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
        ( uuid, newSeed ) =
            Random.step uuidGenerator state.seed

        ( nextPhase, nextStepIndex ) =
            getNextStep ( state.currentPhase, state.currentStepIndex ) state

        currentStep =
            stepAt (unwrapPhase state.currentPhase).steps state.currentStepIndex |> unwrapStep

        nextStep =
            stepAt (unwrapPhase nextPhase).steps nextStepIndex |> unwrapStep

        hasId id player =
            player.id == id

        newPlayer =
            { id = uuid, name = state.newPlayerName, role = None, party = Villagers, markers = [], alive = False }

        firstPhase =
            unwrapPhase configuration

        firstStep =
            stepAt firstPhase.steps 0 |> unwrapStep
    in
    case action of
        SetNewPlayerName name ->
            { state | newPlayerName = name }

        AddPlayer ->
            { state | players = state.players ++ [ newPlayer ], newPlayerName = "", seed = newSeed }

        RemovePlayer id ->
            { state | players = filterNot (hasId id) state.players }

        StepForward ->
            { state | currentPhase = nextPhase, currentStepIndex = nextStepIndex }
                |> currentStep.cleanup
                |> nextStep.init

        SelectCardCategory category ->
            { state | selectedCardCategory = category }

        AddCardToPool card ->
            { state | pool = card :: state.pool }

        AddMarker playerId marker ->
            { state | players = updateIf (hasId playerId) (\p -> { p | markers = p.markers ++ [ marker ] }) state.players }

        RemoveMarker playerId marker ->
            { state | players = updateIf (hasId playerId) (\p -> { p | markers = remove marker p.markers }) state.players }

        KillPlayer id ->
            { state | players = updateIf (hasId id) (\p -> { p | alive = False }) state.players }

        EndGame ->
            firstStep.init { state | currentPhase = Phase firstPhase, currentStepIndex = 0 }


getNextStep : ( Phase, Int ) -> State -> ( Phase, Int )
getNextStep ( currentPhase, currentStepIndex ) state =
    let
        ( newPhase, newStepIndex ) =
            if currentStepIndex + 1 < length (unwrapPhase currentPhase).steps then
                ( currentPhase, currentStepIndex + 1 )

            else
                ( Phase <| getNextPhase <| unwrapPhase currentPhase, 0 )

        newStep =
            stepAt (unwrapPhase newPhase).steps newStepIndex |> unwrapStep
    in
    if newStep.mode state == Skip then
        getNextStep ( newPhase, newStepIndex ) state

    else
        ( newPhase, newStepIndex )


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
