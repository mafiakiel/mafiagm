module Phases.Dawn exposing (dawn)

import Phases.Abstract exposing (abstractPhase)
import Types exposing (Phase(..), Step(..))


dawn : Phase
dawn =
    Phase
        { abstractPhase
            | name = "Morgen"
            , steps =
                []
            , backgroundImage = "%PUBLIC_URL%/img/dawn.jpg"
            , textColor = "white"
        }
