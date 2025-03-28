module UI.ProductCard exposing
    ( viewWithoutColors, viewWithColors
    , viewOpenableWithoutColors, viewOpenableWithColors
    )

{-|

@docs viewWithoutColors, viewWithColors
@docs viewOpenableWithoutColors, viewOpenableWithColors

-}

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes
import Html.Extra
import UI.Color exposing (Color)
import UI.Swatch


type OpenState
    = NotOpenable
    | Openable { isOpen : Bool }


type alias Props msg =
    { name : String
    , price : String
    , valuedAt : Maybe String
    , description : String
    , colors :
        Maybe
            { all : List Color
            , selected : Color
            , onSelect : Color -> msg
            }
    , openState : OpenState
    , imageUrl :
        { color : Maybe Color
        , isOpen : Bool
        }
        -> Maybe String
    , detailUrl : Maybe Color -> Maybe String
    }



-- Public API


viewWithoutColors :
    { name : String
    , price : String
    , valuedAt : Maybe String
    , description : String

    -- The interesting stuff
    , imageUrl : String
    , detailUrl : String
    }
    -> Html msg
viewWithoutColors props =
    view_
        { name = props.name
        , price = props.price
        , valuedAt = props.valuedAt
        , description = props.description

        -- The interesting stuff
        , openState = NotOpenable
        , colors = Nothing
        , imageUrl = \_ -> Just props.imageUrl
        , detailUrl = \_ -> Just props.detailUrl
        }


viewWithColors :
    { name : String
    , price : String
    , valuedAt : Maybe String
    , description : String

    -- The interesting stuff
    , colors : List { color : Color, imageUrl : String, detailUrl : String }
    , selectedColor : Color
    , onSelectColor : Color -> msg
    }
    -> Html msg
viewWithColors props =
    let
        imageUrlDict : Dict String String
        imageUrlDict =
            props.colors
                |> List.map (\{ color, imageUrl } -> ( color.slug, imageUrl ))
                |> Dict.fromList

        detailUrlDict : Dict String String
        detailUrlDict =
            props.colors
                |> List.map (\{ color, detailUrl } -> ( color.slug, detailUrl ))
                |> Dict.fromList
    in
    view_
        { name = props.name
        , price = props.price
        , valuedAt = props.valuedAt
        , description = props.description

        -- The interesting stuff
        , openState = NotOpenable
        , colors =
            Just
                { all = List.map .color props.colors
                , selected = props.selectedColor
                , onSelect = props.onSelectColor
                }
        , imageUrl =
            \{ color } ->
                case color of
                    Nothing ->
                        Nothing

                    Just color_ ->
                        Dict.get color_.slug imageUrlDict
        , detailUrl =
            \color ->
                case color of
                    Nothing ->
                        Nothing

                    Just color_ ->
                        Dict.get color_.slug detailUrlDict
        }


viewOpenableWithoutColors :
    { name : String
    , price : String
    , valuedAt : Maybe String
    , description : String
    , detailUrl : String

    -- The interesting stuff
    , isOpen : Bool
    , imageUrlOpen : String
    , imageUrlClosed : String
    }
    -> Html msg
viewOpenableWithoutColors props =
    view_
        { name = props.name
        , price = props.price
        , valuedAt = props.valuedAt
        , description = props.description

        -- The interesting stuff
        , openState = Openable { isOpen = props.isOpen }
        , colors = Nothing
        , imageUrl =
            \{ isOpen } ->
                if isOpen then
                    Just props.imageUrlOpen

                else
                    Just props.imageUrlClosed
        , detailUrl = \_ -> Just props.detailUrl
        }


viewOpenableWithColors :
    { name : String
    , price : String
    , valuedAt : Maybe String
    , description : String

    -- The interesting stuff
    , isOpen : Bool
    , colors : List { color : Color, imageUrlOpen : String, imageUrlClosed : String, detailUrl : String }
    , selectedColor : Color
    , onSelectColor : Color -> msg
    }
    -> Html msg
viewOpenableWithColors props =
    let
        imageUrlDict : Dict ( String, Int ) String
        imageUrlDict =
            props.colors
                |> List.concatMap
                    (\item ->
                        [ ( ( item.color.slug, boolToInt True ), item.imageUrlOpen )
                        , ( ( item.color.slug, boolToInt False ), item.imageUrlClosed )
                        ]
                    )
                |> Dict.fromList

        detailUrlDict : Dict String String
        detailUrlDict =
            props.colors
                |> List.map (\{ color, detailUrl } -> ( color.slug, detailUrl ))
                |> Dict.fromList
    in
    view_
        { name = props.name
        , price = props.price
        , valuedAt = props.valuedAt
        , description = props.description

        -- The interesting stuff
        , openState = Openable { isOpen = props.isOpen }
        , colors =
            Just
                { all = List.map .color props.colors
                , selected = props.selectedColor
                , onSelect = props.onSelectColor
                }
        , imageUrl =
            \{ color, isOpen } ->
                case color of
                    Nothing ->
                        Nothing

                    Just color_ ->
                        Dict.get ( color_.slug, boolToInt isOpen ) imageUrlDict
        , detailUrl =
            \color ->
                case color of
                    Nothing ->
                        Nothing

                    Just color_ ->
                        Dict.get color_.slug detailUrlDict
        }



-- Underlying implementation


view_ : Props msg -> Html msg
view_ props =
    let
        mainImageUrl : Maybe String
        mainImageUrl =
            props.imageUrl
                { color =
                    case props.colors of
                        Just colors ->
                            Just colors.selected

                        Nothing ->
                            Nothing
                , isOpen =
                    case props.openState of
                        Openable { isOpen } ->
                            isOpen

                        NotOpenable ->
                            False
                }
    in
    Html.div []
        [ viewImageContainer
            { url = mainImageUrl
            , alt = props.name
            }
        , Html.div []
            [ viewNameAndPrice
                { name = props.name
                , price = props.price
                }
            , props.colors
                |> Html.Extra.viewMaybe viewColorSwatch
            , viewDescription props.description
            ]
        ]


viewImageContainer : { url : Maybe String, alt : String } -> Html msg
viewImageContainer { url, alt } =
    Html.div
        [ Html.Attributes.class "relative aspect-square mb-4 bg-gray-100 rounded-lg overflow-hidden" ]
        [ url
            |> Html.Extra.viewMaybe
                (\imageUrl ->
                    Html.img
                        [ Html.Attributes.src imageUrl
                        , Html.Attributes.class "w-full h-full object-cover"
                        , Html.Attributes.alt alt
                        ]
                        []
                )
        ]


viewNameAndPrice : { name : String, price : String } -> Html msg
viewNameAndPrice { name, price } =
    Html.div
        [ Html.Attributes.class "flex justify-between items-start mb-2" ]
        [ Html.h3
            [ Html.Attributes.class "text-lg font-medium" ]
            [ Html.text name ]
        , Html.div
            [ Html.Attributes.class "text-lg" ]
            [ Html.text price ]
        ]


viewColorSwatch :
    { all : List Color
    , selected : Color
    , onSelect : Color -> msg
    }
    -> Html msg
viewColorSwatch props =
    UI.Swatch.view
        { colors = props.all
        , selectedColor = props.selected
        , onSelectColor = props.onSelect
        }


viewDescription : String -> Html msg
viewDescription description =
    Html.p
        [ Html.Attributes.class "mt-2 text-gray-600" ]
        [ Html.text description ]


boolToInt : Bool -> Int
boolToInt b =
    if b then
        1

    else
        0
