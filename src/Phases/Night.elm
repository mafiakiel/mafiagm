module Phases.Night exposing (night)

import Bootstrap.Button as Button
import FontAwesome exposing (icon, skull)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.GameCommons exposing (gameView, instruction)
import Types exposing (Action(..), Phase(..), PlayerControl, Step(..))
import Util exposing (isAlive)


night : Phase
night =
    Phase
        { abstractPhase
            | name = "Nacht"
            , steps =
                [ deaths -- needs to stay at the end!
                ]
            , backgroundImage = "%PUBLIC_URL%/img/night.jpg"
            , textColor = "white"
        }


deaths : Step
deaths =
    Step
        { abstractStep
            | name = "Tode"
            , view = gameView <| [ instruction "Markiere Spieler, die diese Nacht gestorben sind!" ]
            , playerControls = [ killPlayerControl ]
        }


killPlayerControl : PlayerControl
killPlayerControl =
    { label = icon skull
    , action = \player -> KillPlayer player.id
    , options = \_ -> [ Button.danger ]
    , condition = isAlive
    }
