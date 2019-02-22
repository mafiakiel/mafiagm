module Phases.Configuration exposing (configurationPhase, rules)

import Html exposing (text)
import Phases.Abstract exposing (abstractPhase)
import Types exposing (Phase(..), Step(..))


configurationPhase : Phase
configurationPhase =
    Phase
        { abstractPhase
            | name = "Konfiguration"
            , steps =
                \_ ->
                    [ rules
                    ]
            , nextPhase = \_ -> configurationPhase
        }


rules : Step
rules =
    Step
        { name = "Regeln"
        , view = \_ -> text "hallo i bims"
        }
