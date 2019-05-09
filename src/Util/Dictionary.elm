module Util.Dictionary exposing (Dictionary, getString, getValue, toBootstrapSelect)

import Bootstrap.Form.Select as Select
import Html exposing (Html, text)
import List exposing (filter, head, map)
import Types exposing (Action)


type alias Dictionary a =
    List ( a, String )


getString : Dictionary a -> a -> String
getString dictionary value =
    let
        maybeMatch =
            filter (\( v, _ ) -> v == value) dictionary |> head
    in
    case maybeMatch of
        Just ( _, string ) ->
            string

        Nothing ->
            "<value not found in dictionary>"


getValue : Dictionary a -> String -> Maybe a
getValue dictionary string =
    let
        maybeMatch =
            filter (\( _, s ) -> s == string) dictionary |> head
    in
    case maybeMatch of
        Just ( value, _ ) ->
            Just value

        Nothing ->
            Nothing


toBootstrapSelect : Dictionary a -> (a -> Action) -> a -> Html Action
toBootstrapSelect dictionary callback defaultValue =
    let
        entryToItem ( _, label ) =
            Select.item [] [ text label ]

        action label =
            case getValue dictionary label of
                Just value ->
                    callback value

                Nothing ->
                    callback defaultValue
    in
    Select.custom [ Select.onChange action ] (map entryToItem dictionary)
