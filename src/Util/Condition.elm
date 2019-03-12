module Util.Condition exposing (all, any, both)

import List exposing (map, member)


{-| Returns true if both of the conditions return true.
-}
both : (a -> Bool) -> (a -> Bool) -> a -> Bool
both f g a =
    f a && g a


{-| Returns true if all of the conditions return true.
-}
all : List (a -> Bool) -> a -> Bool
all conditions value =
    map (\condition -> condition value) conditions
        |> member False
        |> not


{-| Returns true if any of the conditions returns true.
-}
any : List (a -> Bool) -> a -> Bool
any conditions value =
    map (\condition -> condition value) conditions
        |> member True
