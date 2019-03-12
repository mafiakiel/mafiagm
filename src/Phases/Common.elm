module Phases.Common exposing
    ( addKillMarkerPlayerControl
    , announcement
    , gameView
    , instruction
    , killPlayerControl
    , mafiaStep
    , silenceWarning
    , warning
    )

import Bootstrap.Alert as Alert
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Utilities.Spacing as Spacing
import Data.Strings exposing (partyToString)
import FontAwesome exposing (bullhorn, crosshairs, exclamationTriangle, icon, skull, tasks)
import Html exposing (Html, div, text)
import Html.Attributes exposing (id)
import List exposing (length, map, range)
import Phases.Abstract exposing (abstractStep)
import Types
    exposing
        ( Action(..)
        , Marker(..)
        , Msg
        , Party(..)
        , Player
        , PlayerControl
        , Role(..)
        , State
        , Step
        , StepMode(..)
        )
import Util.Condition exposing (any)
import Util.Phases exposing (combineStepModes, stepAt, stepModeByParty, stepModeByRole, unwrapPhase, unwrapStep)
import Util.Player exposing (hasParty, hasRole)


gameView : List (Html Msg) -> State -> Html Msg
gameView children state =
    div [ id "game-container" ]
        [ div [ id "game-main" ] children
        , div [ id "game-steplist" ] [ stepList state ]
        ]


stepList : State -> Html Msg
stepList state =
    let
        stepsInPhase =
            (unwrapPhase state.currentPhase).steps

        stepsInPhaseIndices =
            stepsInPhase |> length |> (+) -1 |> range 0

        stepIndexToListItem stepIndex =
            let
                step =
                    stepAt stepsInPhase stepIndex |> unwrapStep

                options =
                    if stepIndex == state.currentStepIndex then
                        [ ListGroup.active ]

                    else if step.mode state == Skip then
                        [ ListGroup.disabled ]

                    else
                        []

                badges =
                    if step.mode state == Fake && stepIndex == state.currentStepIndex then
                        [ Badge.badgeDanger [ Spacing.ml1 ] [ text "fake" ] ]

                    else if step.mode state == Fake then
                        [ Badge.badgeSecondary [ Spacing.ml1 ] [ text "fake" ] ]

                    else
                        []
            in
            ListGroup.li options ([ text step.name ] ++ badges)
    in
    ListGroup.ul (map stepIndexToListItem stepsInPhaseIndices)


announcement : String -> Html Msg
announcement content =
    Alert.simplePrimary []
        [ Alert.h4 [] [ icon bullhorn, text " Ansage" ]
        , text content
        ]


instruction : String -> Html Msg
instruction content =
    Alert.simpleWarning []
        [ Alert.h4 [] [ icon tasks, text " Aufgabe" ]
        , text content
        ]


warning : String -> Html Msg
warning content =
    Alert.simpleDanger []
        [ Alert.h4 [] [ icon exclamationTriangle, text " Achtung!" ]
        , text content
        ]


silenceWarning : Html Msg
silenceWarning =
    warning "Das Ergebnis nicht ansagen, sondern per Handzeichen darstellen."


killPlayerControl : (Player -> Bool) -> PlayerControl
killPlayerControl condition =
    { label = icon skull
    , action = \player -> KillPlayer player.id
    , options = always [ Button.danger ]
    , condition = condition
    }


addKillMarkerPlayerControl : (Player -> Bool) -> PlayerControl
addKillMarkerPlayerControl condition =
    { label = icon crosshairs
    , action = \player -> AddMarker player.id Kill
    , options = always [ Button.danger ]
    , condition = condition
    }


mafiaStep =
    { abstractStep
        | name = partyToString Mafia
        , isPlayerActive = always <| any [ hasParty Mafia, hasRole Devil ]
        , mode = combineStepModes [ stepModeByParty Mafia, stepModeByRole Devil ]
    }
