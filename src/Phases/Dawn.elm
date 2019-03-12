module Phases.Dawn exposing (dawn)

import Data.Strings exposing (roleToString)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (announcement, gameView, silenceWarning)
import Types exposing (Phase(..), Role(..), Step(..))
import Util.Phases exposing (stepModeByRole)
import Util.Player exposing (hasRole)


dawn : Phase
dawn =
    Phase
        { abstractPhase
            | name = "Morgen"
            , steps =
                [ detective, privateDetective ]
            , backgroundImage = "%PUBLIC_URL%/img/dawn.jpg"
            , textColor = "white"
        }


detective : Step
detective =
    Step
        { abstractStep
            | name = roleToString Detective
            , view =
                gameView
                    [ announcement "Der Detektiv darf aufwachen und jemanden überprüfen." ]
            , mode = stepModeByRole Detective
            , isPlayerActive = always (hasRole Detective)
        }


privateDetective : Step
privateDetective =
    Step
        { abstractStep
            | name = roleToString PrivateDetective
            , view =
                gameView
                    [ announcement "Der Privatdetektiv darf aufwachen und jemanden überprüfen.", silenceWarning ]
            , mode = stepModeByRole PrivateDetective
            , isPlayerActive = always (hasRole PrivateDetective)
        }
