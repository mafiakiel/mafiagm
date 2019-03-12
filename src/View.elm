module View exposing (view)

import Bootstrap.Alert as Alert
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Table as Table
import Bootstrap.Utilities.Spacing as Spacing
import Data.Strings exposing (partyToString, roleToString)
import FontAwesome exposing (angleRight, award, bed, crosshairs, exclamationTriangle, eye, eyeSlash, heart, icon, plus, redo, shieldAlt, timesCircle, undo, volumeMute)
import Html exposing (Html, div, h1, h2, node, text)
import Html.Attributes exposing (class, href, id, rel, style)
import List exposing (filter, length, map)
import Maybe.Extra exposing (isJust)
import Types exposing (Action(..), Marker(..), Model, Msg(..), Phase(..), State, Step(..))
import UndoList exposing (UndoList)
import Util.Phases exposing (getCurrentStep)


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

        currentStep =
            getCurrentStep model.present

        stepForwardVeto =
            currentStep.stepForwardVeto model.present

        stepForwardVetoMessage =
            case stepForwardVeto of
                Nothing ->
                    text ""

                Just message ->
                    Alert.simpleDanger [] [ icon exclamationTriangle, text " ", text message ]

        background =
            "url(" ++ currentPhase.backgroundImage ++ ")"

        ( stealthModeIcon, stealthModeAction ) =
            if model.present.stealthMode then
                ( eye, Action <| SetStealthMode False )

            else
                ( eyeSlash, Action <| SetStealthMode True )
    in
    div [ id "header", style "background-image" background, style "color" currentPhase.textColor ]
        [ div [ id "header-main" ]
            [ h2 [] [ text currentPhase.name ]
            , h1 [] [ text currentStep.name ]
            ]
        , div [ id "header-veto" ] [ stepForwardVetoMessage ]
        , div [ id "header-buttons" ]
            [ Button.button [ Button.outlineSecondary, Button.onClick stealthModeAction ] [ icon stealthModeIcon ]
            , Button.button [ Button.outlineSecondary, Button.onClick <| Action EndGame ] [ icon timesCircle ]
            , Button.button
                [ Button.onClick <| Action StepForward
                , Button.outlinePrimary
                , Button.disabled <| isJust stepForwardVeto
                , Button.attrs [ id "step-forward" ]
                ]
                [ text "Weiter ", icon angleRight ]
            , Button.button
                [ Button.outlineSecondary
                , Button.onClick Undo
                , Button.disabled <| not <| UndoList.hasPast model
                ]
                [ icon undo ]
            , Button.button
                [ Button.outlineSecondary
                , Button.onClick Redo
                , Button.disabled <| not <| UndoList.hasFuture model
                ]
                [ icon redo ]
            ]
        ]


playerList : State -> Html Msg
playerList state =
    let
        actionSetNewPlayerName name =
            Action <| SetNewPlayerName name

        playerControls =
            (getCurrentStep state).playerControls

        playerControlToButton player control =
            Button.button ([ Button.onClick <| Action <| control.action player, Button.small ] ++ control.options player) [ control.label ]

        playerTableRowOptions player =
            if not player.alive then
                [ Table.rowAttr (class "dead") ]

            else if (getCurrentStep state).isPlayerActive state player then
                [ Table.rowSuccess ]

            else
                []

        sensitiveCellOptions =
            if state.stealthMode then
                [ Table.cellAttr <| class "censored" ]

            else
                []

        playerToTableRow player =
            Table.tr (playerTableRowOptions player)
                [ Table.td [] [ text player.name ]
                , Table.td sensitiveCellOptions [ text <| roleToString player.role ]
                , Table.td sensitiveCellOptions [ text <| partyToString player.party ]
                , Table.td sensitiveCellOptions (map renderMarker player.markers)
                , Table.td [] (filter (\c -> c.condition player) playerControls |> map (playerControlToButton player))
                ]
    in
    div [ id "players" ]
        [ h2 [] [ text <| "Spieler: " ++ String.fromInt (length state.players) ]
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
        , div [ class "spacer" ] []
        ]


renderMarker marker =
    let
        options =
            [ Spacing.mr1 ]

        publicOptions =
            class "public" :: options
    in
    case marker of
        Kill ->
            Badge.pillDanger options [ icon crosshairs ]

        DevilKill ->
            Badge.pillDanger options [ text "Teufel ", icon crosshairs ]

        Protected ->
            Badge.pillSuccess options [ icon shieldAlt ]

        Nominated position ->
            Badge.pillInfo publicOptions [ icon award, text " ", text (String.fromInt position) ]

        Converted ->
            Badge.pillSecondary options [ text "M" ]

        InLove ->
            Badge.pillSecondary options [ icon heart ]

        VisitedByHilda ->
            Badge.badgeInfo options [ icon bed ]

        Muted ->
            Badge.pillDark publicOptions [ icon volumeMute ]


phaseContent : State -> Html Msg
phaseContent state =
    div [ id "phase-viewport" ] [ (getCurrentStep state).view state ]


fontAwesome : Html msg
fontAwesome =
    -- Bootstrap.CDN.fontAwesome is version 4.7.0 but the FontAwesome package needs version 5
    node "link"
        [ rel "stylesheet"
        , href "https://use.fontawesome.com/releases/v5.7.2/css/all.css"
        ]
        []
