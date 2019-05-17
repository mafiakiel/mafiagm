module View exposing (view)

import Bootstrap.Alert as Alert
import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.ButtonGroup as ButtonGroup
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.InputGroup as InputGroup
import Bootstrap.Modal as Modal
import Bootstrap.Table as Table
import Bootstrap.Utilities.Spacing as Spacing
import Data.Strings exposing (partyToString, roleToString)
import FontAwesome
    exposing
        ( angleRight
        , award
        , bed
        , crosshairs
        , exclamation
        , exclamationTriangle
        , eye
        , eyeSlash
        , heart
        , icon
        , pen
        , plus
        , redo
        , ribbon
        , shieldAlt
        , skull
        , timesCircle
        , undo
        , volumeMute
        )
import Html exposing (Html, div, h1, h2, h4, h5, node, p, span, text)
import Html.Attributes exposing (class, href, id, placeholder, rel, style)
import Html.Events exposing (onClick)
import List exposing (filter, length, map, member)
import List.Extra exposing (filterNot)
import Maybe exposing (withDefault)
import Maybe.Extra exposing (isJust, join)
import Types exposing (Action(..), Marker(..), Model, Msg(..), Phase(..), PlayerControl, State, Step(..))
import UndoList exposing (UndoList)
import Util.Condition exposing (conditionalList, ifThenElse)
import Util.Marker exposing (manuallyAddableMarkers)
import Util.Phases exposing (getCurrentStep)
import Util.Player exposing (initPlayer, isAlive, playerById)


view : Model -> Html Msg
view model =
    div [ id "container" ]
        [ CDN.stylesheet
        , fontAwesome
        , header model
        , div [ id "content" ]
            [ playerList model.present |> htmlActionToMsg
            , phaseContent model.present |> htmlActionToMsg
            ]
        , editPlayerModalView model.present |> htmlActionToMsg
        ]


htmlActionToMsg : Html Action -> Html Msg
htmlActionToMsg html =
    Html.map (\action -> Action action) html


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


playerList : State -> Html Action
playerList state =
    let
        playerControls =
            (getCurrentStep state).playerControls

        playerControlToButton player control =
            Button.button
                ([ Button.onClick <| control.action player
                 , Button.small
                 , Button.attrs [ Spacing.mr1 ]
                 ]
                    ++ control.options player
                )
                [ control.label ]

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
                , Table.td [] [ playerControlToButton player editPlayerControl ]
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
                    , Table.th [] []
                    ]
            , tbody = Table.tbody [] (map playerToTableRow state.players)
            }
        , InputGroup.config
            (InputGroup.text [ Input.placeholder "Name", Input.value state.newPlayerName, Input.onInput SetNewPlayerName ])
            |> InputGroup.successors
                [ InputGroup.button [ Button.success, Button.onClick AddPlayer, Button.disabled <| state.newPlayerName == "" ] [ icon plus ] ]
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
            Badge.pillDanger options [ icon crosshairs, text " ", icon exclamation ]

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

        Alibi ->
            Badge.pillSuccess options [ icon ribbon ]

        CustomMarker label public ->
            Badge.pillSecondary (ifThenElse public publicOptions options) [ text label ]


editPlayerControl : PlayerControl
editPlayerControl =
    { label = icon pen
    , action = \player -> EditPlayer player.id
    , options = always [ Button.light ]
    , condition = always True
    }


editPlayerModalView : State -> Html Action
editPlayerModalView state =
    let
        editPlayerModal =
            state.editPlayerModal

        visibility =
            if isJust editPlayerModal.playerId then
                Modal.shown

            else
                Modal.hidden

        player =
            Maybe.map (playerById state.players) editPlayerModal.playerId
                |> join
                |> withDefault initPlayer

        addableMarkers =
            filterNot (\marker -> member marker player.markers) manuallyAddableMarkers

        addableCustomMarkers =
            filterNot (\marker -> member marker player.markers) state.customMarkers

        renderRemovableMarker marker =
            span [ onClick <| RemoveMarker player.id marker, style "cursor" "pointer" ] [ renderMarker marker ]

        renderAddableMarker marker =
            span [ onClick <| AddMarker player.id marker, style "cursor" "pointer" ] [ renderMarker marker ]

        stopEditingPlayer =
            SetEditPlayerModal { editPlayerModal | playerId = Nothing }
    in
    Modal.config stopEditingPlayer
        |> Modal.small
        |> Modal.hideOnBackdropClick True
        |> Modal.h3 [] [ text "Spieler bearbeiten" ]
        |> Modal.body []
            (conditionalList
                [ ( length player.markers > 0, h4 [] [ text "Marker entfernen" ] )
                , ( True, p [] (map renderRemovableMarker player.markers) )
                , ( length addableMarkers > 0, h4 [] [ text "Marker hinzufügen" ] )
                , ( True, p [] (map renderAddableMarker addableMarkers) )
                , ( True, h5 [] [ text "Benutzerdefiniert" ] )
                , ( True, customMarkerForm state )
                , ( True, p [] (map renderAddableMarker addableCustomMarkers) )
                ]
            )
        |> Modal.footer []
            [ Button.button
                [ Button.onClick <| KillPlayer player.id
                , Button.danger
                , Button.disabled <| not <| isAlive player
                ]
                [ icon skull, text " Töten" ]
            , Button.button [ Button.onClick stopEditingPlayer ] [ text "Schließen" ]
            ]
        |> Modal.view visibility


customMarkerForm : State -> Html Action
customMarkerForm state =
    let
        editPlayerModal =
            state.editPlayerModal

        setLabel label =
            SetEditPlayerModal { editPlayerModal | customMarkerLabel = label }

        setPublic public =
            SetEditPlayerModal { editPlayerModal | customMarkerPublic = public }
    in
    Form.formInline []
        [ ButtonGroup.radioButtonGroup []
            [ ButtonGroup.radioButton
                (editPlayerModal.customMarkerPublic == True)
                [ Button.light, Button.onClick <| setPublic True ]
                [ icon eye ]
            , ButtonGroup.radioButton
                (editPlayerModal.customMarkerPublic == False)
                [ Button.light, Button.onClick <| setPublic False ]
                [ icon eyeSlash ]
            ]
        , Input.text
            [ Input.attrs [ placeholder "Beschriftung", style "width" "120px", class "ml-sm-2" ]
            , Input.onInput setLabel
            , Input.value editPlayerModal.customMarkerLabel
            ]
        , Button.button
            [ Button.success
            , Button.attrs [ class "ml-sm-2 my-2" ]
            , Button.onClick CreateCustomMarker
            ]
            [ icon plus ]
        ]


phaseContent : State -> Html Action
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
