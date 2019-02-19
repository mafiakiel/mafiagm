module View exposing (view)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Html exposing (Html, div, text)
import Model exposing (Model)
import UndoList exposing (UndoList)
import Update exposing (Msg(..))


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , div [] [ text (String.fromInt model.present) ]
        , Button.button [ Button.onClick Increment, Button.primary ] [ text "+" ]
        , Button.button [ Button.onClick Undo, Button.disabled <| not <| UndoList.hasPast model ] [ text "<" ]
        , Button.button [ Button.onClick Redo, Button.disabled <| not <| UndoList.hasFuture model ] [ text ">" ]
        ]
