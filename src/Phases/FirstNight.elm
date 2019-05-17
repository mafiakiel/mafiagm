module Phases.FirstNight exposing (firstNight)

import Data.Strings exposing (roleToString)
import FontAwesome exposing (heart, icon)
import Html exposing (Html)
import List exposing (filter, length)
import List.Extra exposing (notMember)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (customCardsStep, gameView, mafiaStep, simpleAnnouncement, simpleInstruction)
import Types exposing (Action(..), CustomCardStep(..), Marker(..), Party(..), Phase(..), PlayerControl, Role(..), State, Step(..), StepMode(..))
import Util.Phases exposing (getCurrentStep, stepModeByRole)
import Util.Player exposing (hasRole, isInChurch)


firstNight : Phase
firstNight =
    Phase
        { abstractPhase
            | name = "Erste Nacht"
            , steps = [ mafia, church, cupid, customCardsStep WakeUpAtFirstNight ]
            , backgroundImage = "%PUBLIC_URL%/img/night.jpg"
            , textColor = "white"
        }


indicateGroupSize : State -> Html Action
indicateGroupSize state =
    let
        currentStep =
            getCurrentStep state

        numberOfActivePlayers =
            filter (currentStep.isPlayerActive state) state.players |> length |> String.fromInt
    in
    simpleInstruction ("Zeige die Anzahl der Spieler an, die jetzt wach sein sollten: " ++ numberOfActivePlayers)


mafia : Step
mafia =
    Step
        { mafiaStep
            | view = \state -> gameView [ simpleAnnouncement "Die Mafia darf aufwachen und sich erkennen. 😏", indicateGroupSize state ] state
        }


church : Step
church =
    Step
        { abstractStep
            | name = "Kirche"
            , view = \state -> gameView [ simpleAnnouncement "Die Kirche darf aufwachen und sich erkennen. 😏", indicateGroupSize state ] state
            , isPlayerActive = always isInChurch
            , mode = always Skip
        }


cupid : Step
cupid =
    Step
        { abstractStep
            | name = roleToString Cupid
            , view = gameView [ simpleAnnouncement "Amor darf aufwachen und zwei Mitspieler verlieben." ]
            , isPlayerActive = always (hasRole Cupid)
            , playerControls = cupidPlayerControls
            , mode = stepModeByRole Cupid
        }


cupidPlayerControls : List PlayerControl
cupidPlayerControls =
    [ { label = icon heart
      , action = \player -> AddMarker player.id InLove
      , options = always []
      , condition = \player -> player.role /= Cupid && notMember InLove player.markers
      }
    ]
