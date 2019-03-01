module Update exposing (update)

import List exposing (filter, length, map)
import List.Extra exposing (elemIndex, filterNot, getAt, remove, updateIf)
import Phases.Configuration
import Phases.Dawn
import Phases.Day
import Phases.FirstNight
import Phases.Night
import Random
import Types exposing (Action(..), Marker(..), Model, Msg(..), Party(..), Phase(..), Role(..), State, Step(..))
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

        (Phase currentPhase) =
            state.currentPhase

        ( nextPhase, nextStepIndex ) =
            getNextStep state

        nextStep =
            stepAt (unwrapPhase nextPhase).steps nextStepIndex |> unwrapStep

        hasId id player =
            player.id == id

        newPlayer =
            { id = uuid, name = state.newPlayerName, role = None, party = Villagers, markers = [] }
    in
    case action of
        SetNewPlayerName name ->
            { state | newPlayerName = name }

        AddPlayer ->
            { state | players = state.players ++ [ newPlayer ], newPlayerName = "", seed = newSeed }

        RemovePlayer id ->
            { state | players = filterNot (hasId id) state.players }

        StepForward ->
            nextStep.init { state | currentPhase = nextPhase, currentStepIndex = nextStepIndex }

        SelectCardCategory category ->
            { state | selectedCardCategory = category }

        AddCardToPool card ->
            { state | pool = card :: state.pool }

        AddMarker playerId marker ->
            { state | players = updateIf (hasId playerId) (\p -> { p | markers = p.markers ++ [ marker ] }) state.players }

        RemoveMarker playerId marker ->
            { state | players = updateIf (hasId playerId) (\p -> { p | markers = remove marker p.markers }) state.players }


getNextStep : State -> ( Phase, Int )
getNextStep state =
    let
        (Phase currentPhase) =
            state.currentPhase

        nextPhase =
            getNextPhase currentPhase
    in
    if state.currentStepIndex + 1 < length currentPhase.steps then
        ( state.currentPhase, state.currentStepIndex + 1 )

    else
        ( Phase nextPhase, 0 )


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
