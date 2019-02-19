module Msg exposing (Action(..), Msg(..))


type Action
    = SetNewPlayerName String
    | AddPlayer


type Msg
    = Undo
    | Redo
    | Action Action
