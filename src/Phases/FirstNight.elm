module Phases.FirstNight exposing (firstNight)

import Html exposing (text)
import Phases.Abstract exposing (abstractPhase)
import Types exposing (Phase(..), Step(..))


firstNight : Phase
firstNight =
    Phase
        { abstractPhase
            | name = "Erste Nacht"
            , steps =
                \_ ->
                    []
        }
