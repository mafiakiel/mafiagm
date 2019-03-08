module Phases.Day exposing (day)

import Bootstrap.Button as Button
import FontAwesome exposing (award, icon)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (announcement, gameView, instruction, killPlayerControl)
import Types exposing (Action(..), Phase(..), PlayerControl, Step(..))
import Util.Condition exposing (both)
import Util.Marker exposing (isNominatedMarker)
import Util.Player exposing (isAlive, isNominated)
import Util.Update exposing (removeMarkersFromAllPlayers, resetNextNominationPostion, setStealthMode)


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
                gameView <|
                    [ announcement "Alle wachen auf."
                    , instruction "Nimm Nominierungen entgegen."
                    ]
            , playerControls = [ nominatePlayerControl ]
            , init = resetNextNominationPostion >> setStealthMode True
        }


nominatePlayerControl : PlayerControl
nominatePlayerControl =
    { label = icon award
    , action = \player -> NominatePlayer player.id
    , options = always [ Button.info ]
    , condition = isAlive
    }


election : Step
election =
    Step
        { abstractStep
            | name = "Abstimmung"
            , view =
                gameView <| [ instruction "Führe die Abstimmung durch." ]
            , isPlayerActive = always isNominated
        }


hanging : Step
hanging =
    Step
        { abstractStep
            | name = "Hinrichtung"
            , view =
                gameView <|
                    [ instruction "Markiere den Spieler, der gehängt werden soll."
                    , announcement "... wurde gehängt. Er/sie war ..."
                    , announcement "Alle schlafen ein."
                    ]
            , playerControls = [ killPlayerControl (both isNominated isAlive) ]
            , isPlayerActive = always isNominated
            , cleanup = removeMarkersFromAllPlayers isNominatedMarker >> setStealthMode False
        }
