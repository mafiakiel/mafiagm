module Phases.Day exposing (day)

import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Utilities.Spacing as Spacing
import FontAwesome exposing (award, clock, icon)
import Html exposing (Html, div, text)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (announcement, gameView, instruction, killPlayerControl)
import Types exposing (Action(..), Msg(..), Phase(..), PlayerControl, State, Step(..))
import Util.Condition exposing (both)
import Util.Marker exposing (isNominatedMarker)
import Util.Player exposing (isAlive, isNominated)
import Util.Update exposing (removeMarkersFromAllPlayers, resetNextNominationPostion, setNominationCountdownRunning, setStealthMode)


day : Phase
day =
    Phase
        { abstractPhase
            | name = "Tag"
            , steps = [ nomination, election, hanging ]
            , backgroundImage = "%PUBLIC_URL%/img/day.jpg"
            , textColor = "white"
        }


nomination : Step
nomination =
    Step
        { abstractStep
            | name = "Nominierung"
            , view =
                \state ->
                    gameView
                        [ announcement "Alle wachen auf."
                        , instruction "Nimm Nominierungen entgegen."
                        , nominationCountdown state
                        ]
                        state
            , playerControls = [ nominatePlayerControl ]
            , init = resetNextNominationPostion >> setStealthMode True
            , cleanup = setNominationCountdownRunning False
        }


nominatePlayerControl : PlayerControl
nominatePlayerControl =
    { label = icon award
    , action = \player -> NominatePlayer player.id
    , options = always [ Button.info ]
    , condition = both isAlive (not << isNominated)
    }


nominationCountdown : State -> Html Msg
nominationCountdown state =
    let
        {- A custom element is used so that the countdown state does not interfere with undo/redo -}
        remainingTime =
            Html.node "x-countdown"
                [ property "duration" <| Encode.int state.nominationCountdownDuration
                , property "running" <| Encode.bool state.nominationCountdownRunning
                , on "finished" <| Decode.succeed <| Action NominationCountdownFinished
                ]
                []
    in
    Card.config []
        |> Card.headerH4 [] [ icon clock, text " Countdown" ]
        |> Card.block []
            [ Block.custom
                (div []
                    [ remainingTime
                    , Button.button
                        [ Button.attrs [ Spacing.mr1 ]
                        , Button.onClick <| Action <| SetNominationCountdownDuration <| state.nominationCountdownDuration - 5
                        , Button.disabled (state.nominationCountdownRunning || state.nominationCountdownDuration <= 5)
                        ]
                        [ text "-5" ]
                    , Button.button
                        [ Button.attrs [ Spacing.mr1 ]
                        , Button.onClick <| Action <| SetNominationCountdownDuration <| state.nominationCountdownDuration + 5
                        , Button.disabled state.nominationCountdownRunning
                        ]
                        [ text "+5" ]
                    , Button.button
                        [ Button.primary
                        , Button.onClick <| Action <| SetNominationCountdownRunning True
                        , Button.disabled state.nominationCountdownRunning
                        ]
                        [ text "Starten" ]
                    ]
                )
            ]
        |> Card.view


election : Step
election =
    Step
        { abstractStep
            | name = "Abstimmung"
            , view =
                gameView [ instruction "Führe die Abstimmung durch." ]
            , isPlayerActive = always isNominated
        }


hanging : Step
hanging =
    Step
        { abstractStep
            | name = "Hinrichtung"
            , view =
                gameView
                    [ instruction "Markiere den Spieler, der gehängt werden soll."
                    , announcement "... wurde gehängt. Er/sie war ..."
                    , announcement "Alle schlafen ein."
                    ]
            , playerControls = [ killPlayerControl (both isNominated isAlive) ]
            , isPlayerActive = always isNominated
            , cleanup = removeMarkersFromAllPlayers isNominatedMarker >> setStealthMode False
        }
