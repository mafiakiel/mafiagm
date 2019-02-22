module Phases.Abstract exposing (abstractPhase)

import Types exposing (Phase(..))
import Util exposing (unwrapPhase)


abstractPhase =
    unwrapPhase abstractPhaseWrapper


abstractPhaseWrapper =
    Phase
        { name = "Please override phase name!"
        , nextPhase = \_ -> abstractPhaseWrapper
        , steps = \_ -> []
        }
