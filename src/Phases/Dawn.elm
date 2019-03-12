module Phases.Dawn exposing (dawn, muter)

import Bootstrap.Button as Button
import Data.Strings exposing (roleToString)
import FontAwesome exposing (icon, ribbon, volumeMute)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (announcement, gameView, silenceWarning)
import Types exposing (Action(..), Marker(..), Party(..), Phase(..), PlayerControl, Role(..), Step(..))
import Util.Condition exposing (all, both)
import Util.Phases exposing (stepModeByPartyAndRole, stepModeByRole)
import Util.Player exposing (hasMarker, hasParty, hasRole, isAlive)
import Util.Update exposing (removeMarkersFromAllPlayers)


dawn : Phase
dawn =
    Phase
        { abstractPhase
            | name = "Morgen"
            , steps =
                [ detective, privateDetective, inspector, villagerSpy, mafiaSpy, muter, crackWhore ]
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


mafiaSpy : Step
mafiaSpy =
    Step
        { abstractStep
            | name = "Mafia-Spion"
            , view =
                gameView
                    [ announcement "Der Mafia-Spion darf aufwachen und jemanden überprüfen.", silenceWarning ]
            , mode = stepModeByPartyAndRole Mafia Spy
            , isPlayerActive = always <| both (hasRole Spy) (hasParty Mafia)
        }


muter : Step
muter =
    Step
        { abstractStep
            | name = roleToString Muter
            , view =
                gameView
                    [ announcement "Der Muter darf aufwachen und jemanden muten." ]
            , mode = stepModeByRole Muter
            , isPlayerActive = always (hasRole Muter)
            , playerControls = [ muterPlayerControl ]
            , init = removeMarkersFromAllPlayers <| (==) Muted
        }


muterPlayerControl : PlayerControl
muterPlayerControl =
    { label = icon volumeMute
    , action = \player -> AddMarker player.id Muted
    , options = always [ Button.dark ]
    , condition = both isAlive (not << hasMarker Muted)
    }


crackWhore : Step
crackWhore =
    Step
        { abstractStep
            | name = roleToString CrackWhore
            , view =
                gameView
                    [ announcement "Die Nutte darf aufwachen und jemandem ein Alibi geben." ]
            , mode = stepModeByRole CrackWhore
            , isPlayerActive = always (hasRole CrackWhore)
            , playerControls = [ crackWhorePlayerControl ]
        }


crackWhorePlayerControl : PlayerControl
crackWhorePlayerControl =
    { label = icon ribbon
    , action = \player -> AddMarker player.id Alibi
    , options = always [ Button.success ]
    , condition = all [ isAlive, not << hasRole CrackWhore, not << hasMarker Alibi ]
    }
