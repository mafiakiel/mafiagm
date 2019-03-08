module Util.Player exposing (hasId, hasParty, hasRole, isAlive, isInChurch, isNominated)

import List exposing (any, member)
import Types exposing (Marker(..), Party, Player, Role(..))
import Util.Marker exposing (isNominatedMarker)
import Uuid exposing (Uuid)


hasId : Uuid -> Player -> Bool
hasId id player =
    player.id == id


hasRole : Role -> Player -> Bool
hasRole role player =
    player.role == role


hasParty : Party -> Player -> Bool
hasParty party player =
    player.party == party


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
