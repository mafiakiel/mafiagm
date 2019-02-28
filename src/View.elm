module View exposing (view)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table
import Data.Strings exposing (partyToString, roleToString)
import FontAwesome exposing (angleRight, icon, plus, redo, trash, undo)
import Html exposing (Html, div, h1, h2, node, text)
import Html.Attributes exposing (href, id, rel)
import List exposing (filter, length, map)
import Maybe.Extra exposing (isJust)
import Types exposing (Action(..), Model, Msg(..), Phase(..), State, Step(..))
import UndoList exposing (UndoList)
import Util exposing (unwrapStep)


view : Model -> Html Msg
view model =
    div [ id "container" ]
        [ CDN.stylesheet
        , fontAwesome
        , header model
        , div [ id "content" ]
            [ playerList model.present
            , phaseContent model.present
            ]
        ]


header : Model -> Html Msg
header model =
    let
        (Phase currentPhase) =
            model.present.currentPhase

        (Step currentStep) =
            model.present.currentStep

        stepForwardVeto =
            currentStep.stepForwardVeto model.present

        stepForwardVetoMessage =
            case stepForwardVeto of
                Nothing ->
                    text ""

                Just message ->
                    text message
    in
    div [ id "header" ]
        [ h1 [] [ text currentPhase.name ]
        , h2 [] [ text currentStep.name ]
        , Button.button [ Button.onClick Undo, Button.disabled <| not <| UndoList.hasPast model ] [ icon undo ]
        , Button.button [ Button.onClick Redo, Button.disabled <| not <| UndoList.hasFuture model ] [ icon redo ]
        , Button.button [ Button.onClick <| Action StepForward, Button.primary, Button.disabled <| isJust stepForwardVeto ] [ text "Weiter ", icon angleRight ]
        , stepForwardVetoMessage
        ]


playerList : State -> Html Msg
playerList state =
    let
        actionSetNewPlayerName name =
            Action <| SetNewPlayerName name

        actionRemovePlayer id =
            Action <| RemovePlayer id

        playerControls =
            (unwrapStep state.currentStep).playerControls

        playerControlToButton player control =
            Button.button ([ Button.onClick <| Action <| control.action player, Button.small ] ++ control.options player) [ control.label ]

        playerToTableRow player =
            Table.tr []
                [ Table.td [] [ text player.name ]
                , Table.td [] [ text <| roleToString player.role ]
                , Table.td [] [ text <| partyToString player.party ]
                , Table.td [] []
                , Table.td [] (filter (\c -> c.condition player) playerControls |> map (playerControlToButton player))
                ]
    in
    div [ id "players" ]
        [ h2 [] [ text <| "Spieler (" ++ String.fromInt (length state.players) ++ ")" ]
        , Table.table
            { options = []
            , thead =
                Table.simpleThead
                    [ Table.th [] [ text "Name" ]
                    , Table.th [] [ text "Rolle" ]
                    , Table.th [] [ text "Partei" ]
                    , Table.th [] [ text "Marker" ]
                    , Table.th [] [ text "Aktionen" ]
                    ]
            , tbody = Table.tbody [] (map playerToTableRow state.players)
            }
        , InputGroup.config
            (InputGroup.text [ Input.placeholder "Name", Input.value state.newPlayerName, Input.onInput actionSetNewPlayerName ])
            |> InputGroup.successors
                [ InputGroup.button [ Button.success, Button.onClick <| Action AddPlayer, Button.disabled <| state.newPlayerName == "" ] [ icon plus ] ]
            |> InputGroup.view
        ]


phaseContent : State -> Html Msg
phaseContent state =
    let
        (Step currentStep) =
            state.currentStep
    in
    div [ id "phase-viewport" ] [ currentStep.view state ]


fontAwesome : Html msg
fontAwesome =
    -- Bootstrap.CDN.fontAwesome is version 4.7.0 but the FontAwesome package needs version 5
    node "link"
        [ rel "stylesheet"
        , href "https://use.fontawesome.com/releases/v5.7.2/css/all.css"
        ]
        []
