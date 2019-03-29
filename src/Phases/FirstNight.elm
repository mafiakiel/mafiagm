module Phases.FirstNight exposing (firstNight)

import Data.Strings exposing (roleToString)
import FontAwesome exposing (heart, icon)
import List.Extra exposing (notMember)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (customCardsStep, gameView, mafiaStep, simpleAnnouncement)
import Types exposing (Action(..), CustomCardStep(..), Marker(..), Party(..), Phase(..), PlayerControl, Role(..), Step(..), StepMode(..))
import Util.Phases exposing (stepModeByRole)
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


mafia : Step
mafia =
    Step
        { mafiaStep
            | view = gameView [ simpleAnnouncement "Die Mafia darf aufwachen und sich erkennen. 😏" ]
        }


church : Step
church =
    Step
        { abstractStep
            | name = "Kirche"
            , view = gameView [ simpleAnnouncement "Die Kirche darf aufwachen und sich erkennen. 😏" ]
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
