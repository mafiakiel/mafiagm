module Phases.Night exposing (night)

import Bootstrap.Button as Button
import Data.Strings exposing (roleToString)
import FontAwesome exposing (bed, icon)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (announcement, gameView, instruction, killPlayerControl)
import Types exposing (Action(..), Marker(..), Phase(..), PlayerControl, Role(..), Step(..))
import Util.Condition exposing (all)
import Util.Phases exposing (stepModeByRole)
import Util.Player exposing (hasMarker, hasRole, isAlive)
import Util.Update exposing (removeMarkersFromAllPlayers)


night : Phase
night =
    Phase
        { abstractPhase
            | name = "Nacht"
            , steps =
                [ wildHilda
                , deaths -- needs to stay at the end!
                ]
            , backgroundImage = "%PUBLIC_URL%/img/night.jpg"
            , textColor = "white"
        }


deaths : Step
deaths =
    Step
        { abstractStep
            | name = "Tode"
            , view =
                gameView
                    [ announcement "Gestorben sind: ..."
                    , instruction "Markiere Spieler, die diese Nacht gestorben sind!"
                    ]
            , playerControls = [ killPlayerControl isAlive ]
            , cleanup = removeMarkersFromAllPlayers ((==) VisitedByHilda)
        }


wildHilda : Step
wildHilda =
    Step
        { abstractStep
            | name = roleToString WildHilda
            , view =
                gameView
                    [ announcement "Die Wilde Hilde darf aufwachen und jemanden besuchen." ]
            , mode = stepModeByRole WildHilda
            , isPlayerActive = always (hasRole WildHilda)
            , playerControls = [ wildHildaPlayerControl ]
        }


wildHildaPlayerControl : PlayerControl
wildHildaPlayerControl =
    { label = icon bed
    , action = \player -> AddMarker player.id VisitedByHilda
    , options = always [ Button.info ]
    , condition = all [ isAlive, not << hasRole WildHilda, not << hasMarker VisitedByHilda ]
    }
