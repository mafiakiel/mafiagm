module Phases.Day exposing (day)

import Html exposing (text)
import Phases.Abstract exposing (abstractPhase)
import Types exposing (Phase(..), Step(..))


day : Phase
day =
    Phase
        { abstractPhase
            | name = "Tag"
            , steps =
                []
        }
