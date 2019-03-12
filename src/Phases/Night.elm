module Phases.Night exposing (night)

import Bootstrap.Button as Button
import Data.Strings exposing (partyToString, roleToString)
import FontAwesome exposing (bed, crosshairs, icon, shieldAlt)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (addKillMarkerPlayerControl, announcement, gameView, instruction, killPlayerControl, mafiaStep)
import Types exposing (Action(..), Marker(..), Party(..), Phase(..), PlayerControl, Role(..), Step(..), StepMode(..))
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
                , doctor
                , mafia
                , devil
                , vampires
                , secretAgent
                , church
                , zombies
                , witch
                , shoemaker
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
            , cleanup =
                removeMarkersFromAllPlayers <|
                    any
                        [ (==) VisitedByHilda
                        , (==) Protected
                        , (==) Kill
                        , (==) DevilKill
                        ]
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


doctor : Step
doctor =
    Step
        { abstractStep
            | name = roleToString Doctor
            , mode = always Skip
        }


mafia : Step
mafia =
    Step
        { mafiaStep
            | view = gameView [ announcement "Die Mafia darf aufwachen und jemanden töten." ]
            , playerControls = [ addKillMarkerPlayerControl isAlive ]
        }


devil : Step
devil =
    Step
        { abstractStep
            | name = roleToString Devil
            , view =
                gameView
                    [ announcement "Der Teufel darf aufwachen und jemanden töten." ]
            , mode = stepModeByRole Devil
            , isPlayerActive = always (hasRole Devil)
            , playerControls = [ devilPlayerControl ]
        }


devilPlayerControl : PlayerControl
devilPlayerControl =
    { label = icon crosshairs
    , action = \player -> AddMarker player.id DevilKill
    , options = always [ Button.danger ]
    , condition = all [ isAlive, not << hasRole Devil, not << hasMarker DevilKill ]
    }


vampires : Step
vampires =
    Step
        { abstractStep
            | name = partyToString Vampires
            , mode = always Skip
        }


secretAgent : Step
secretAgent =
    Step
        { abstractStep
            | name = roleToString SecretAgent
            , mode = always Skip
        }


church : Step
church =
    Step
        { abstractStep
            | name = "Kirche"
            , mode = always Skip
        }


zombies : Step
zombies =
    Step
        { abstractStep
            | name = partyToString Zombies
            , mode = always Skip
        }


witch : Step
witch =
    Step
        { abstractStep
            | name = roleToString Witch
            , mode = always Skip
        }


shoemaker : Step
shoemaker =
    Step
        { abstractStep
            | name = roleToString Shoemaker
            , mode = always Skip
        }
