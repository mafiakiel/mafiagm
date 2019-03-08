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
    , view = always <| text "Please override step view!"
    , init = identity
    , cleanup = identity
    , stepForwardVeto = always Nothing
    , playerControls = []
    , isPlayerActive = always <| always False
    , mode = always Execute
    }
