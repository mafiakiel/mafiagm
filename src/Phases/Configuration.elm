module Phases.Configuration exposing (configuration, rules)

import Html exposing (text)
import Phases.Abstract exposing (abstractPhase)
import Types exposing (Phase(..), Step(..))


configuration : Phase
configuration =
    Phase
        { abstractPhase
            | name = "Konfiguration"
            , steps =
                \_ ->
                    [ rules
                    ]
        }


rules : Step
rules =
    Step
        { name = "Regeln"
        , view = \_ -> text "hallo i bims"
        }
