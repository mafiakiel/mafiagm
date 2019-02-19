module Msg exposing (Action(..), Msg(..))

import Uuid exposing (Uuid)


type Action
    = SetNewPlayerName String
    | AddPlayer
    | RemovePlayer Uuid


type Msg
    = Undo
    | Redo
    | Action Action
