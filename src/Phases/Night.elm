module Phases.Night exposing (night)

import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (announcement, gameView, instruction, killPlayerControl)
import Types exposing (Action(..), Phase(..), PlayerControl, Step(..))
import Util.Player exposing (isAlive)


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
            , view =
                gameView
                    [ announcement "Gestorben sind: ..."
                    , instruction "Markiere Spieler, die diese Nacht gestorben sind!"
                    ]
            , playerControls = [ killPlayerControl isAlive ]
        }
