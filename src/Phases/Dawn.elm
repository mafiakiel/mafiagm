module Phases.Dawn exposing (dawn)

import Html exposing (text)
import Phases.Abstract exposing (abstractPhase)
import Types exposing (Phase(..), Step(..))


dawn : Phase
dawn =
    Phase
        { abstractPhase
            | name = "Morgen"
            , steps =
                []
        }
