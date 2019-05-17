module Phases.Common exposing
    ( addKillMarkerPlayerControl
    , customCardsStep
    , gameView
    , killPlayerControl
    , mafiaStep
    , silenceWarning
    , simpleAnnouncement
    , simpleInstruction
    , simpleWarning
    )

import Bootstrap.Alert as Alert
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Utilities.Spacing as Spacing
import Data.Strings exposing (partyToString)
import FontAwesome exposing (bullhorn, crosshairs, exclamationTriangle, icon, skull, tasks)
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (id)
import List exposing (filter, length, map, member, range)
import Phases.Abstract exposing (abstractStep)
import Types
    exposing
        ( Action(..)
        , CardType(..)
        , CustomCardStep
        , Marker(..)
        , Party(..)
        , Player
        , PlayerControl
        , Role(..)
        , State
        , Step(..)
        , StepMode(..)
        )
import Util.Condition exposing (any, both)
import Util.Phases
    exposing
        ( combineStepModes
        , stepAt
        , stepModeByParty
        , stepModeByPartyAndRole
        , stepModeByRole
        , unwrapPhase
        , unwrapStep
        )
import Util.Player exposing (hasMarker, hasParty, hasRole)


gameView : List (Html Action) -> State -> Html Action
gameView children state =
    div [ id "game-container" ]
        [ div [ id "game-main" ] children
        , div [ id "game-steplist" ] [ stepList state ]
        ]


stepList : State -> Html Action
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
                        [ Badge.badgeDark [ Spacing.ml1 ] [ text "fake" ] ]

                    else if step.mode state == Fake then
                        [ Badge.badgeSecondary [ Spacing.ml1 ] [ text "fake" ] ]

                    else
                        []
            in
            ListGroup.li options ([ text step.name ] ++ badges)
    in
    ListGroup.ul (map stepIndexToListItem stepsInPhaseIndices)


simpleAnnouncement : String -> Html Action
simpleAnnouncement content =
    Alert.simplePrimary []
        [ Alert.h4 [] [ icon bullhorn, text " Ansage" ]
        , text content
        ]


simpleInstruction : String -> Html Action
simpleInstruction content =
    instruction [ text content ]


instruction : List (Html Action) -> Html Action
instruction content =
    Alert.simpleWarning []
        ([ Alert.h4 [] [ icon tasks, text " Aufgabe" ]
         ]
            ++ content
        )


simpleWarning : String -> Html Action
simpleWarning content =
    Alert.simpleDanger []
        [ Alert.h4 [] [ icon exclamationTriangle, text " Achtung!" ]
        , text content
        ]


silenceWarning : Html Action
silenceWarning =
    simpleWarning "Das Ergebnis nicht ansagen, sondern per Handzeichen darstellen."


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
    , condition = both condition (not << hasMarker Kill)
    }


mafiaStep =
    { abstractStep
        | name = partyToString Mafia
        , isPlayerActive = always <| any [ hasParty Mafia, hasRole Devil ]
        , mode = combineStepModes [ stepModeByParty Mafia, stepModeByRole Devil ]
    }


customCardsStep : CustomCardStep -> Step
customCardsStep step =
    let
        isActive card =
            case card.cardType of
                CustomCard steps ->
                    member step steps

                _ ->
                    False

        cards state =
            filter isActive state.customCards

        stepModes state =
            map (\card -> stepModeByPartyAndRole card.party card.role) (cards state)

        isPlayerActive state player =
            cards state
                |> filter (\card -> player.role == card.role && player.party == card.party)
                |> length
                |> (>) 0

        roleName card =
            case card.role of
                CustomRole name ->
                    text name

                _ ->
                    text "can't happen"

        roles state =
            map (\card -> li [] [ roleName card ]) (cards state)
    in
    Step
        { abstractStep
            | name = "Custom"
            , view = \state -> gameView [ instruction [ text "Lasse folgende Rollen aufwachen:", ul [] (roles state) ] ] state
            , isPlayerActive = isPlayerActive
            , mode = \state -> combineStepModes (stepModes state) state
        }
