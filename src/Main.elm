module App exposing (main)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Browser
import Html exposing (Html, div, text)


type alias Model =
    Int


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , Button.button [ Button.onClick Decrement, Button.primary ] [ text "-" ]
        , div [] [ text (String.fromInt model) ]
        , Button.button [ Button.onClick Increment, Button.primary ] [ text "+" ]
        ]


main =
    Browser.sandbox
        { init = 0
        , view = view
        , update = update
        }
