module Update exposing (update)

import Data.Strings exposing (customCardText)
import List exposing (filter, length)
import List.Extra exposing (filterNot, remove, updateIf)
import Model exposing (initCustomCardModal)
import Phases.Configuration exposing (configuration)
import Phases.Dawn exposing (muter)
import Phases.Day
import Phases.FirstNight
import Phases.Night
import Random
import Types exposing (Action(..), CardType(..), Marker(..), Model, Msg(..), Party(..), Phase(..), Role(..), State, Step(..), StepMode(..))
import UndoList exposing (UndoList)
import Util.Phases exposing (stepAt, unwrapPhase, unwrapStep)
import Util.Player exposing (hasId)
import Util.Update exposing (addMarkerToPlayer, removeMarkersFromAllPlayers, setNominationCountdownRunning, setStealthMode)
import Uuid exposing (Uuid, uuidGenerator)


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

        newPlayer =
            { id = uuid, name = state.newPlayerName, role = None, party = Villagers, markers = [], alive = False }

        firstPhase =
            unwrapPhase configuration

        firstStep =
            stepAt firstPhase.steps 0 |> unwrapStep

        stepForward =
            { state | currentPhase = nextPhase, currentStepIndex = nextStepIndex }
                |> currentStep.cleanup
                |> nextStep.init

        createCustomCardFromModal =
            { party = state.customCardModal.party
            , role = CustomRole state.customCardModal.role
            , text = customCardText state.customCardModal
            , cardType = CustomCard state.customCardModal.steps
            }
    in
    case action of
        SetNewPlayerName name ->
            { state | newPlayerName = name }

        AddPlayer ->
            { state | players = state.players ++ [ newPlayer ], newPlayerName = "", seed = newSeed }

        RemovePlayer id ->
            { state | players = filterNot (hasId id) state.players }

        StepForward ->
            stepForward

        SelectCardCategory category ->
            { state | selectedCardCategory = category }

        AddCardToPool card ->
            { state | pool = card :: state.pool }

        RemoveCardFromPool card ->
            { state | pool = remove card state.pool }

        AddCardToFakePool card ->
            { state | pool = filter ((/=) card) state.pool, fakePool = card :: state.fakePool }

        RemoveCardFromFakePool card ->
            { state | fakePool = remove card state.fakePool }

        AddMarker playerId marker ->
            addMarkerToPlayer playerId marker state

        KillPlayer id ->
            { state | players = updateIf (hasId id) (\p -> { p | alive = False }) state.players }
                |> cleanupAfterKill

        EndGame ->
            { state | currentPhase = Phase firstPhase, currentStepIndex = 0 }
                |> setStealthMode False
                |> currentStep.cleanup
                |> firstStep.init

        NominatePlayer id ->
            { state | nextNominationPosition = state.nextNominationPosition + 1 }
                |> addMarkerToPlayer id (Nominated state.nextNominationPosition)

        SetStealthMode isEnabled ->
            setStealthMode isEnabled state

        SetNominationCountdownDuration duration ->
            { state | nominationCountdownDuration = duration }

        SetNominationCountdownRunning isRunning ->
            setNominationCountdownRunning isRunning state

        NominationCountdownFinished ->
            stepForward

        SetCustomCardModal customCardModal ->
            { state | customCardModal = customCardModal }

        CreateCustomCard ->
            { state | customCards = state.customCards ++ [ createCustomCardFromModal ], customCardModal = initCustomCardModal }


cleanupAfterKill : State -> State
cleanupAfterKill state =
    if (unwrapStep muter).mode state == Skip then
        removeMarkersFromAllPlayers ((==) Muted) state

    else
        state


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
