module Phases.Common exposing (announcement, gameView, instruction, killPlayerControl)

import Bootstrap.Alert as Alert
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Utilities.Spacing as Spacing
import FontAwesome exposing (bullhorn, icon, skull, tasks)
import Html exposing (Html, div, text)
import Html.Attributes exposing (id)
import List exposing (length, map, range)
import Types exposing (Action(..), Msg, Player, PlayerControl, State, StepMode(..))
import Util.Phases exposing (stepAt, unwrapPhase, unwrapStep)


gameView : List (Html Msg) -> State -> Html Msg
gameView children state =
    div [ id "game-container" ]
        [ div [ id "game-main" ]
            [ div [ id "game-children" ] children
            , div [ id "game-raffle" ] [ text "TODO: Raffle" ]
            ]
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
                    if step.mode state == Fake then
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


killPlayerControl : (Player -> Bool) -> PlayerControl
killPlayerControl condition =
    { label = icon skull
    , action = \player -> KillPlayer player.id
    , options = always [ Button.danger ]
    , condition = condition
    }
