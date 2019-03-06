module Phases.GameCommons exposing (gameView, announcement)

import Bootstrap.Alert as Alert
import Bootstrap.Badge as Badge
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Utilities.Spacing as Spacing
import Html exposing (Html, div, text)
import Html.Attributes exposing (id)
import List exposing (length, map, range)
import Types exposing (Msg, State, StepMode(..))
import Util exposing (stepAt, unwrapPhase, unwrapStep)
import FontAwesome exposing (icon, bullhorn)


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
announcement content = Alert.simplePrimary [] [
    Alert.h4 [] [icon bullhorn, text " Ansage"]
    , text content
    ]
