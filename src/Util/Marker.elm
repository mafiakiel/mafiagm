module Util.Marker exposing (isNominatedMarker)

import Types exposing (Marker(..))


isNominatedMarker : Marker -> Bool
isNominatedMarker marker =
    case marker of
        Nominated _ ->
            True

        _ ->
            False
