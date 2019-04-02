module Util.Update exposing
    ( addMarkerToPlayer
    , removeMarkerFromPlayer
    , removeMarkersFromAllPlayers
    , resetNextNominationPosition
    , setNominationCountdownRunning
    , setStealthMode
    )

import List exposing (map)
import List.Extra exposing (filterNot, remove, updateIf)
import Types exposing (Marker, State)
import Util.Player exposing (hasId)
import Uuid exposing (Uuid)


addMarkerToPlayer : Uuid -> Marker -> State -> State
addMarkerToPlayer playerId marker state =
    { state | players = updateIf (hasId playerId) (\p -> { p | markers = p.markers ++ [ marker ] }) state.players }


removeMarkerFromPlayer : Uuid -> Marker -> State -> State
removeMarkerFromPlayer playerId marker state =
    { state | players = updateIf (hasId playerId) (\p -> { p | markers = remove marker p.markers }) state.players }


removeMarkersFromAllPlayers : (Marker -> Bool) -> State -> State
removeMarkersFromAllPlayers condition state =
    let
        removeMarkers player =
            { player | markers = filterNot condition player.markers }
    in
    { state | players = map removeMarkers state.players }


setStealthMode : Bool -> State -> State
setStealthMode isEnabled state =
    { state | stealthMode = isEnabled }


resetNextNominationPosition : State -> State
resetNextNominationPosition state =
    { state | nextNominationPosition = 1 }


setNominationCountdownRunning : Bool -> State -> State
setNominationCountdownRunning isRunning state =
    { state | nominationCountdownRunning = isRunning }
