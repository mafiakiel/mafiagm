module Util exposing (unwrapPhase)

import Types exposing (Phase(..), Step(..))


unwrapPhase wrapped =
    let
        (Phase unwrapped) =
            wrapped
    in
    unwrapped


unwrapStep wrapped =
    let
        (Step unwrapped) =
            wrapped
    in
    unwrapped
