module View exposing (view)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import FontAwesome exposing (icon, redo, undo)
import Html exposing (Html, div, h1, h2, node, text)
import Html.Attributes exposing (href, id, rel)
import Model exposing (Model, State)
import Msg exposing (Msg(..))
import UndoList exposing (UndoList)


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
    div [ id "header" ]
        [ h1 [] [ text "Name der Phase" ]
        , h2 [] [ text "Beschreibung der Phase" ]
        , Button.button [ Button.onClick Undo, Button.disabled <| not <| UndoList.hasPast model ] [ icon undo ]
        , Button.button [ Button.onClick Redo, Button.disabled <| not <| UndoList.hasFuture model ] [ icon redo ]
        ]


playerList : State -> Html Msg
playerList state =
    div [ id "players" ] [ text "Liste der Spieler" ]


phaseContent : State -> Html Msg
phaseContent state =
    div [ id "phase-viewport" ] [ text "Phasenspezifischer Inhalt" ]


fontAwesome : Html msg
fontAwesome =
    -- Bootstrap.CDN.fontAwesome is version 4.7.0 but the FontAwesome package needs version 5
    node "link"
        [ rel "stylesheet"
        , href "https://use.fontawesome.com/releases/v5.7.2/css/all.css"
        ]
        []
