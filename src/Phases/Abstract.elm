module Phases.Abstract exposing (abstractPhase)

import Types exposing (Phase(..))
import Util exposing (unwrapPhase)


abstractPhase =
    { name = "Please override phase name!"
    , nextPhase = \_ -> Phase abstractPhase
    , steps = \_ -> []
    }
