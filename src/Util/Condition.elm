module Util.Condition exposing (both)


both : (a -> Bool) -> (a -> Bool) -> a -> Bool
both f g a =
    f a && g a
