module Phases.Night exposing (night)

import Html exposing (text)
import Phases.Abstract exposing (abstractPhase)
import Types exposing (Phase(..), Step(..))


night : Phase
night =
    Phase
        { abstractPhase
            | name = "Nacht"
            , steps =
                \_ ->
                    []
        }
