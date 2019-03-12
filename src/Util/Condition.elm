module Util.Condition exposing (all, both)

import List exposing (map, member)


both : (a -> Bool) -> (a -> Bool) -> a -> Bool
both f g a =
    f a && g a


all : List (a -> Bool) -> a -> Bool
all conditions value =
    map (\condition -> condition value) conditions
        |> member False
        |> not
