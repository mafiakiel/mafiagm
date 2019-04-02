module Util.Player exposing (hasId, hasMarker, hasParty, hasRole, initPlayer, isAlive, isInChurch, isNominated)

import List exposing (any, member)
import Random exposing (initialSeed)
import Types exposing (Marker(..), Party(..), Player, Role(..))
import Util.Marker exposing (isNominatedMarker)
import Uuid exposing (Uuid, uuidGenerator)


hasId : Uuid -> Player -> Bool
hasId id player =
    player.id == id


hasRole : Role -> Player -> Bool
hasRole role player =
    player.role == role


hasParty : Party -> Player -> Bool
hasParty party player =
    player.party == party


hasMarker : Marker -> Player -> Bool
hasMarker marker player =
    member marker player.markers


isInChurch : Player -> Bool
isInChurch player =
    member Converted player.markers
        || player.role
        == Pope
        || player.role
        == Monk
        || player.role
        == MonkInLove


isAlive : Player -> Bool
isAlive player =
    player.alive


isNominated : Player -> Bool
isNominated player =
    any isNominatedMarker player.markers


initPlayer : Player
initPlayer =
    let
        ( id, _ ) =
            Random.step uuidGenerator <| initialSeed 0
    in
    { id = id, name = "New Player", role = None, party = Villagers, markers = [], alive = False }
