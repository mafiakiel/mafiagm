module Phases.FirstNight exposing (firstNight)

import Data.Strings exposing (partyToString, roleToString)
import FontAwesome exposing (heart, icon)
import List.Extra exposing (notMember)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (announcement, gameView)
import Types exposing (Action(..), Marker(..), Party(..), Phase(..), PlayerControl, Role(..), Step(..))
import Util.Phases exposing (stepModeByParty, stepModeByRole)
import Util.Player exposing (hasParty, hasRole, isInChurch)


firstNight : Phase
firstNight =
    Phase
        { abstractPhase
            | name = "Erste Nacht"
            , steps = [ mafia, church, cupid ]
            , backgroundImage = "%PUBLIC_URL%/img/night.jpg"
            , textColor = "white"
        }


mafia : Step
mafia =
    Step
        { abstractStep
            | name = partyToString Mafia
            , view = gameView <| [ announcement "Die Mafia darf aufwachen und sich erkennen. 😏" ]
            , isPlayerActive = always (hasParty Mafia)
            , mode = stepModeByParty Mafia
        }


church : Step
church =
    Step
        { abstractStep
            | name = "Kirche"
            , view = gameView <| [ announcement "Die Kirche darf aufwachen und sich erkennen. 😏" ]
            , isPlayerActive = always isInChurch

            -- TODO: mode
        }


cupid : Step
cupid =
    Step
        { abstractStep
            | name = roleToString Cupid
            , view = gameView <| [ announcement "Amor darf aufwachen und zwei Mitspieler verlieben." ]
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
