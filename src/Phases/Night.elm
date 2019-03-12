module Phases.Night exposing (night)

import Bootstrap.Button as Button
import Data.Strings exposing (roleToString)
import FontAwesome exposing (bed, icon, shieldAlt)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (announcement, gameView, instruction, killPlayerControl)
import Types exposing (Action(..), Marker(..), Phase(..), PlayerControl, Role(..), Step(..))
import Util.Condition exposing (all, any, both)
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
                , guardianAngel
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
            , cleanup = removeMarkersFromAllPlayers <| any [ (==) VisitedByHilda, (==) Protected ]
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


guardianAngel : Step
guardianAngel =
    Step
        { abstractStep
            | name = roleToString GuardianAngel
            , view =
                gameView
                    [ announcement "Der Schutzengel darf aufwachen und jemanden schützen." ]
            , mode = stepModeByRole GuardianAngel
            , isPlayerActive = always (hasRole GuardianAngel)
            , playerControls = [ guardianAngelPlayerControl ]
        }


guardianAngelPlayerControl : PlayerControl
guardianAngelPlayerControl =
    { label = icon shieldAlt
    , action = \player -> AddMarker player.id Protected
    , options = always [ Button.success ]
    , condition = both isAlive (not << hasMarker Protected)
    }
