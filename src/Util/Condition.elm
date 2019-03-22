module Util.Condition exposing (all, any, both, conditionalList)

import List exposing (filter, map, member)
import Util.Misc exposing (apply)


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
    map (apply value) conditions
        |> member True


{-| Takes a list of condition/value tuples and returns a list of all values where the condition returns true.
-}
conditionalList : List ( Bool, a ) -> List a
conditionalList list =
    list
        |> filter (\( condition, _ ) -> condition)
        |> map (\( _, value ) -> value)
