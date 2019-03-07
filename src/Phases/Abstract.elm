module Phases.Abstract exposing (abstractPhase, abstractStep)

import Html exposing (text)
import Types exposing (Phase(..), StepMode(..))


abstractPhase =
    { name = "Please override phase name!"
    , steps = []
    , backgroundImage = "Please override phase background image!"
    , textColor = "black"
    }


abstractStep =
    { name = "Please override step name!"
    , view = \_ -> text "Please override step view!"
    , init = \state -> state
    , stepForwardVeto = \_ -> Nothing
    , playerControls = []
    , isPlayerActive = \_ _ -> False
    , mode = \_ -> Execute
    }
