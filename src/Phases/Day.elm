module Phases.Day exposing (day)

import Phases.Abstract exposing (abstractPhase)
import Types exposing (Phase(..), Step(..))


day : Phase
day =
    Phase
        { abstractPhase
            | name = "Tag"
            , steps =
                []
            , backgroundImage = "%PUBLIC_URL%/img/day.jpg"
            , textColor = "white"
        }
