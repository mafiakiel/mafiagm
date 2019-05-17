module Phases.Day exposing (day)

import Bootstrap.Button as Button
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Utilities.Spacing as Spacing
import FontAwesome exposing (award, clock, icon)
import Html exposing (Html, div, li, ol, text)
import Html.Attributes exposing (property)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import List exposing (filter, map, sortBy)
import List.Extra exposing (find)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (gameView, information, killPlayerControl, simpleAnnouncement, simpleInstruction)
import Types exposing (Action(..), Marker(..), Phase(..), PlayerControl, State, Step(..))
import Util.Condition exposing (all, any, both)
import Util.Marker exposing (isNominatedMarker)
import Util.Player exposing (hasMarker, isAlive, isNominated)
import Util.Update
    exposing
        ( removeMarkersFromAllPlayers
        , resetNextNominationPosition
        , setNominationCountdownRunning
        , setStealthMode
        )


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
                        [ simpleAnnouncement "Alle wachen auf."
                        , simpleInstruction "Nimm Nominierungen entgegen."
                        , nominatedPlayerList state
                        , nominationCountdown state
                        ]
                        state
            , playerControls = [ nominatePlayerControl ]
            , init = resetNextNominationPosition >> setStealthMode True
            , cleanup = setNominationCountdownRunning False
        }


nominatePlayerControl : PlayerControl
nominatePlayerControl =
    { label = icon award
    , action = \player -> NominatePlayer player.id
    , options = always [ Button.info ]
    , condition = both isAlive (not << isNominated)
    }


nominatedPlayerList : State -> Html Action
nominatedPlayerList state =
    let
        playerWithNominationPos player =
            case find isNominatedMarker player.markers of
                Just (Nominated position) ->
                    ( player, position )

                _ ->
                    ( player, -1 )

        nominatedPlayers =
            state.players
                |> map playerWithNominationPos
                |> filter (\( _, pos ) -> pos > 0)
                |> sortBy (\( _, pos ) -> pos)
                |> map (\( player, _ ) -> li [] [ text player.name ])
    in
    information
        [ text "Nominerte Spieler:"
        , ol [ Spacing.mb0 ] nominatedPlayers
        ]


nominationCountdown : State -> Html Action
nominationCountdown state =
    let
        remainingTime =
            Html.node "x-countdown"
                [ property "duration" <| Encode.int state.nominationCountdownDuration
                , property "running" <| Encode.bool state.nominationCountdownRunning
                , on "finished" <| Decode.succeed NominationCountdownFinished
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
                        , Button.onClick <| SetNominationCountdownDuration <| state.nominationCountdownDuration - 5
                        , Button.disabled (state.nominationCountdownRunning || state.nominationCountdownDuration <= 5)
                        ]
                        [ text "-5" ]
                    , Button.button
                        [ Button.attrs [ Spacing.mr1 ]
                        , Button.onClick <| SetNominationCountdownDuration <| state.nominationCountdownDuration + 5
                        , Button.disabled state.nominationCountdownRunning
                        ]
                        [ text "+5" ]
                    , Button.button
                        [ Button.primary
                        , Button.onClick <| SetNominationCountdownRunning True
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
                gameView [ simpleInstruction "Führe die Abstimmung durch." ]
            , isPlayerActive = always isNominated
        }


hanging : Step
hanging =
    Step
        { abstractStep
            | name = "Hinrichtung"
            , view =
                gameView
                    [ simpleInstruction "Markiere den Spieler, der gehängt werden soll."
                    , simpleAnnouncement "... wurde gehängt. Er/sie war ..."
                    , simpleAnnouncement "Alle schlafen ein."
                    ]
            , playerControls = [ killPlayerControl <| all [ isAlive, isNominated, not << hasMarker Alibi ] ]
            , isPlayerActive = always isNominated
            , init = setStealthMode False
            , cleanup = removeMarkersFromAllPlayers <| any [ isNominatedMarker, (==) Alibi ]
        }
