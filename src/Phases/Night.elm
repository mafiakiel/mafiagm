module Phases.Night exposing (night)

import Bootstrap.Button as Button
import Data.Strings exposing (partyToString, roleToString)
import FontAwesome exposing (bed, crosshairs, exclamation, icon, shieldAlt)
import Html exposing (span, text)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (addKillMarkerPlayerControl, customCardsStep, gameView, killPlayerControl, mafiaStep, simpleAnnouncement, simpleInstruction)
import Types exposing (Action(..), CustomCardStep(..), Marker(..), Party(..), Phase(..), PlayerControl, Role(..), Step(..), StepMode(..))
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
                , customCardsStep WakeUpAtNight
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
                    [ simpleAnnouncement "Gestorben sind: ..."
                    , simpleInstruction "Markiere Spieler, die diese Nacht gestorben sind!"
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
                    [ simpleAnnouncement "Die Wilde Hilde darf aufwachen und jemanden besuchen." ]
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
                    [ simpleAnnouncement "Der Schutzengel darf aufwachen und jemanden schützen." ]
            , mode = stepModeByRole GuardianAngel
            , isPlayerActive = always (hasRole GuardianAngel)
            , playerControls = [ addProtectedMarkerPlayerControl ]
        }


addProtectedMarkerPlayerControl : PlayerControl
addProtectedMarkerPlayerControl =
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
            | view = gameView [ simpleAnnouncement "Die Mafia darf aufwachen und jemanden töten." ]
            , playerControls = [ addKillMarkerPlayerControl isAlive ]
        }


devil : Step
devil =
    Step
        { abstractStep
            | name = roleToString Devil
            , view =
                gameView
                    [ simpleAnnouncement "Der Teufel darf aufwachen und jemanden töten." ]
            , mode = stepModeByRole Devil
            , isPlayerActive = always (hasRole Devil)
            , playerControls = [ devilPlayerControl ]
        }


devilPlayerControl : PlayerControl
devilPlayerControl =
    { label = span [] [ icon crosshairs, text " ", icon exclamation ]
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
            , view =
                gameView
                    [ simpleAnnouncement "Der Agent darf aufwachen und (wenn er möchte) jemanden töten." ]
            , mode = stepModeByRole SecretAgent
            , isPlayerActive = always (hasRole SecretAgent)
            , playerControls = [ addKillMarkerPlayerControl isAlive ]
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
            , view =
                gameView
                    [ simpleAnnouncement "Die Hexe darf aufwachen.", simpleInstruction "Zeige an, welche Spieler diese Nacht sterben werden." ]
            , mode = stepModeByRole Witch
            , isPlayerActive = always (hasRole Witch)
            , playerControls = [ addKillMarkerPlayerControl isAlive, addProtectedMarkerPlayerControl ]
        }


shoemaker : Step
shoemaker =
    Step
        { abstractStep
            | name = roleToString Shoemaker
            , mode = always Skip
        }
