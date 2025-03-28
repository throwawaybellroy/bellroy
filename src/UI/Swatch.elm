module UI.Swatch exposing (Props, view)

import Html exposing (Html)
import Html.Attributes
import Html.Attributes.Extra
import Html.Events
import UI.Color


type alias Props msg =
    { colors : List UI.Color.Color
    , selectedColor : UI.Color.Color
    , onSelectColor : UI.Color.Color -> msg
    }


view : Props msg -> Html msg
view props =
    Html.div
        [ Html.Attributes.class "flex flex-row gap-2" ]
        (List.map
            (\color ->
                let
                    isSelected : Bool
                    isSelected =
                        color.slug == props.selectedColor.slug

                    classes : String
                    classes =
                        "relative w-6 h-6 rounded-full cursor-pointer bg-center"
                in
                Html.div
                    [ Html.Attributes.class classes
                    , UI.Color.bgStyle color.type_
                    , Html.Events.onClick (props.onSelectColor color)
                    , Html.Attributes.title color.name
                    , Html.Attributes.Extra.attributeIf isSelected <| Html.Attributes.class "border-1"
                    , Html.Attributes.Extra.attributeIf isSelected <| UI.Color.borderStyle color.type_
                    ]
                    [ Html.div
                        [ Html.Attributes.Extra.attributeIf isSelected <|
                            Html.Attributes.class "absolute inset-0 rounded-full border-2 border-white pointer-events-none"
                        ]
                        []
                    ]
            )
            props.colors
        )
