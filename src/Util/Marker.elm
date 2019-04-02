module Util.Marker exposing (isNominatedMarker, manuallyAddableMarkers)

import Types exposing (Marker(..))


manuallyAddableMarkers : List Marker
manuallyAddableMarkers =
    [ Kill
    , DevilKill
    , Protected
    , Converted
    , InLove
    , VisitedByHilda
    , Muted
    , Alibi
    ]


isNominatedMarker : Marker -> Bool
isNominatedMarker marker =
    case marker of
        Nominated _ ->
            True

        _ ->
            False
