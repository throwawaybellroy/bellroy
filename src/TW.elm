module TW exposing (mod)

{-| Tailwind helpers

@docs mod

-}

import Html
import Html.Attributes


{-|

    TW.mod "after" "content-[''] absolute inset-0 bg-red-500"

    TW.mod "group-hover" "bg-red-500"

-}
mod : String -> String -> Html.Attribute msg
mod name value =
    value
        |> String.split " "
        |> List.map (\v -> name ++ ":" ++ v)
        |> String.join " "
        |> Html.Attributes.class
