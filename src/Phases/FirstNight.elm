module Phases.FirstNight exposing (firstNight)

import Html exposing (text)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Types exposing (Party(..), Phase(..), Step(..))


firstNight : Phase
firstNight =
    Phase
        { abstractPhase
            | name = "Erste Nacht"
            , steps =
                [ mafia ]
        }


mafia : Step
mafia =
    Step
        { abstractStep
            | name = "Mafia"
            , view = \_ -> text "Die Mafia darf aufwachen und sich erkennen. 😏"
            , isPlayerActive = \player _ -> player.party == Mafia
        }
