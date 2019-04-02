module Util.Misc exposing (apply)


apply : a -> (a -> b) -> b
apply a f =
    f a
