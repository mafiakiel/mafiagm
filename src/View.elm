module View exposing (view)

import FontAwesome exposing (icon, undo, redo)
import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Html exposing (Html, div, text, node)
import Html.Attributes exposing (href, rel)
import Model exposing (Model)
import UndoList exposing (UndoList)
import Update exposing (Msg(..))


view : Model -> Html Msg
view model =
    Grid.containerFluid []
        [ CDN.stylesheet, fontAwesome
        , div [] [ text (String.fromInt model.present) ]
        , Button.button [ Button.onClick Increment, Button.primary ] [ text "+" ]
        , Button.button [ Button.onClick Undo, Button.disabled <| not <| UndoList.hasPast model ] [ icon undo ]
        , Button.button [ Button.onClick Redo, Button.disabled <| not <| UndoList.hasFuture model ] [ icon redo ]
        ]

-- Bootstrap.CDN.fontAwesome is version 4.7.0 but the FontAwesome package needs version 5
fontAwesome : Html msg
fontAwesome =
    node "link"
        [ rel "stylesheet"
        , href "https://use.fontawesome.com/releases/v5.7.2/css/all.css"
        ]
    []