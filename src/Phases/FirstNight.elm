module Phases.FirstNight exposing (firstNight)

import Data.Strings exposing (partyToString, roleToString)
import FontAwesome exposing (heart, icon)
import List.Extra exposing (notMember)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.GameCommons exposing (announcement, gameView)
import Types exposing (Action(..), Marker(..), Party(..), Phase(..), PlayerControl, Role(..), Step(..))
import Util exposing (isInChurch, stepModeByParty, stepModeByRole)


firstNight : Phase
firstNight =
    Phase
        { abstractPhase
            | name = "Erste Nacht"
            , steps = [ mafia, church, cupid ]
        }


mafia : Step
mafia =
    Step
        { abstractStep
            | name = partyToString Mafia
            , view = gameView <| [announcement "Die Mafia darf aufwachen und sich erkennen. 😏"]
            , isPlayerActive = \player _ -> player.party == Mafia
            , mode = stepModeByParty Mafia
        }


church : Step
church =
    Step
        { abstractStep
            | name = "Kirche"
            , view = gameView <| [announcement "Die Kirche darf aufwachen und sich erkennen. 😏"]
            , isPlayerActive = \player _ -> isInChurch player

            -- TODO: mode
        }


cupid : Step
cupid =
    Step
        { abstractStep
            | name = roleToString Cupid
            , view = gameView <| [announcement "Amor darf aufwachen und zwei Mitspieler verlieben."]
            , isPlayerActive = \player _ -> player.role == Cupid
            , playerControls = cupidPlayerControls
            , mode = stepModeByRole Cupid
        }


cupidPlayerControls : List PlayerControl
cupidPlayerControls =
    [ { label = icon heart
      , action = \player -> AddMarker player.id InLove
      , options = \_ -> []
      , condition = \player -> player.role /= Cupid && notMember InLove player.markers
      }
    ]
