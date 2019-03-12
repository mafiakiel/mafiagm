module Phases.Dawn exposing (dawn)

import Data.Strings exposing (roleToString)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (announcement, gameView, silenceWarning)
import Types exposing (Party(..), Phase(..), Role(..), Step(..))
import Util.Condition exposing (both)
import Util.Phases exposing (stepModeByPartyAndRole, stepModeByRole)
import Util.Player exposing (hasParty, hasRole)


dawn : Phase
dawn =
    Phase
        { abstractPhase
            | name = "Morgen"
            , steps =
                [ detective, privateDetective, inspector, villagerSpy ]
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


inspector : Step
inspector =
    Step
        { abstractStep
            | name = roleToString Inspector
            , view =
                gameView
                    [ announcement "Der Inspektor darf aufwachen und jemanden überprüfen." ]
            , mode = stepModeByRole Inspector
            , isPlayerActive = always (hasRole Inspector)
        }


villagerSpy : Step
villagerSpy =
    Step
        { abstractStep
            | name = "Bürger-Spion"
            , view =
                gameView
                    [ announcement "Der Bürger-Spion darf aufwachen und jemanden überprüfen.", silenceWarning ]
            , mode = stepModeByPartyAndRole Villagers Spy
            , isPlayerActive = always <| both (hasRole Spy) (hasParty Villagers)
        }
