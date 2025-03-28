module UI.Color exposing
    ( Color
    , Type, color, img
    , bgStyle, borderStyle
    )

{-|

@docs Color
@docs Type, color, img
@docs bgStyle, borderStyle

-}

import Html
import Html.Attributes


type alias Color =
    { slug : String
    , name : String
    , type_ : Type
    }


type Type
    = BgColor String
    | BgImage { url : String, borderColor : String }


color : String -> Type
color name =
    BgColor name


img : { url : String, borderColor : String } -> Type
img data =
    BgImage data


bgStyle : Type -> Html.Attribute msg
bgStyle type_ =
    case type_ of
        BgColor rgb ->
            Html.Attributes.style "background-color" rgb

        BgImage data ->
            Html.Attributes.style "background-image" ("url('" ++ data.url ++ "')")


borderStyle : Type -> Html.Attribute msg
borderStyle type_ =
    case type_ of
        BgColor rgb ->
            Html.Attributes.style "border-color" rgb

        BgImage data ->
            Html.Attributes.style "border-color" data.borderColor
