module Phases.Abstract exposing (abstractPhase, abstractStep)

import Html exposing (text)
import Types exposing (Phase(..))
import Util exposing (unwrapPhase)


abstractPhase =
    { name = "Please override phase name!"
    , steps = []
    }


abstractStep =
    { name = "Please override step name!"
    , view = \_ -> text "Please override step view!"
    , init = \state -> state
    , stepForwardVeto = \_ -> Nothing
    , playerControls = []
    , isPlayerActive = \_ _ -> False
    }
