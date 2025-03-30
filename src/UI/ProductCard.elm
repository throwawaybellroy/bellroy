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
import Html.Attributes.Extra
import Html.Events
import Html.Extra
import Html.Keyed
import Svg
import Svg.Attributes
import UI.Color exposing (Color)
import UI.Swatch


type OpenState msg
    = NotOpenable
    | Openable
        { isOpen : Bool
        , setOpen : Bool -> msg
        }


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
    , openState : OpenState msg
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

    -- The interesting stuff
    , isOpen : Bool
    , setOpen : Bool -> msg
    , imageUrlOpen : String
    , imageUrlClosed : String
    , detailUrl : String
    }
    -> Html msg
viewOpenableWithoutColors props =
    view_
        { name = props.name
        , price = props.price
        , valuedAt = props.valuedAt
        , description = props.description

        -- The interesting stuff
        , openState =
            Openable
                { isOpen = props.isOpen
                , setOpen = props.setOpen
                }
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
    , setOpen : Bool -> msg
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
        , openState =
            Openable
                { isOpen = props.isOpen
                , setOpen = props.setOpen
                }
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
                { color = props.colors |> Maybe.map .selected
                , isOpen =
                    case props.openState of
                        Openable { isOpen } ->
                            isOpen

                        NotOpenable ->
                            False
                }

        detailUrl : String
        detailUrl =
            props.colors
                |> Maybe.map .selected
                |> props.detailUrl
                |> Maybe.withDefault ""
    in
    Html.Keyed.node "div"
        [ Html.Attributes.class
            """
            relative group w-[400px] h-[500px] bg-[#f7f7f7] flex flex-col
            shadow-product-card hover:shadow-product-card-hover
            transition-shadow duration-200
            """
        ]
        (List.concat
            [ viewPreloadTags props
            , [ ( "image"
                , viewImageContainer
                    { url = mainImageUrl
                    , alt = props.name
                    , openState = props.openState
                    }
                )
              , ( "info"
                , Html.div [ Html.Attributes.class "px-4 py-4" ]
                    [ viewName
                        { name = props.name
                        , detailUrl = detailUrl
                        }
                    , viewPrice
                        { price = props.price
                        , valuedAt = props.valuedAt
                        }
                    , props.colors
                        |> Html.Extra.viewMaybe viewColorSwatch
                    , viewDescription props.description
                    ]
                )
              ]
            ]
        )


viewPreloadTags : Props msg -> List ( String, Html msg )
viewPreloadTags props =
    let
        closedUrls : List String
        closedUrls =
            case props.colors of
                Just colors ->
                    colors.all
                        |> List.filterMap
                            (\color ->
                                props.imageUrl
                                    { color = Just color
                                    , isOpen = False
                                    }
                            )

                Nothing ->
                    props.imageUrl
                        { color = Nothing
                        , isOpen = False
                        }
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []

        openUrls : List String
        openUrls =
            case props.openState of
                Openable _ ->
                    case props.colors of
                        Just colors ->
                            colors.all
                                |> List.filterMap
                                    (\color ->
                                        props.imageUrl
                                            { color = Just color
                                            , isOpen = True
                                            }
                                    )

                        Nothing ->
                            props.imageUrl
                                { color = Nothing
                                , isOpen = True
                                }
                                |> Maybe.map List.singleton
                                |> Maybe.withDefault []

                NotOpenable ->
                    []
    in
    (closedUrls ++ openUrls)
        |> List.indexedMap
            (\i url ->
                ( "preload-" ++ String.fromInt i
                , Html.node "link"
                    [ Html.Attributes.rel "preload"
                    , Html.Attributes.href url
                    , Html.Attributes.attribute "as" "image"
                    ]
                    []
                )
            )


viewImageContainer : { url : Maybe String, alt : String, openState : OpenState msg } -> Html msg
viewImageContainer { url, alt, openState } =
    Html.div
        [ Html.Attributes.class "relative overflow-hidden flex-1 flex items-center justify-conter" ]
        [ url
            |> Html.Extra.viewMaybe
                (\imageUrl ->
                    Html.img
                        [ Html.Attributes.src imageUrl
                        , Html.Attributes.class "w-full object-contain max-h-64"
                        , Html.Attributes.alt alt
                        ]
                        []
                )
        , case openState of
            Openable { isOpen, setOpen } ->
                viewOpenCloseButton
                    { isOpen = isOpen
                    , setOpen = setOpen
                    }

            NotOpenable ->
                Html.Extra.nothing
        ]


viewOpenCloseButton : { isOpen : Bool, setOpen : Bool -> msg } -> Html msg
viewOpenCloseButton { isOpen, setOpen } =
    Html.Keyed.node "button"
        [ Html.Attributes.class
            """
            absolute z-20 px-2 py-1 top-0 right-0 flex flex-row gap-2
            bg-gray-200 items-center justify-center uppercase tracking-wider
            text-xs cursor-pointer opacity-0 group-hover:opacity-100
            transition-opacity duration-200
            """
        , Html.Events.onClick (setOpen (not isOpen))
        ]
        [ ( "text"
          , Html.text
                (if isOpen then
                    "Close"

                 else
                    "Show inside"
                )
          )
        , ( "plus"
          , Html.span
                [ Html.Attributes.class "w-4 h-4 transition-transform duration-200 ease-in-out origin-center"
                , Html.Attributes.Extra.attributeIf isOpen (Html.Attributes.class "rotate-45")
                ]
                [ plus ]
          )
        ]


plus : Html msg
plus =
    Svg.svg
        [ Svg.Attributes.viewBox "0 0 24 24"
        , Svg.Attributes.fill "none"
        , Svg.Attributes.stroke "currentColor"
        , Svg.Attributes.strokeWidth "2"
        , Svg.Attributes.strokeLinecap "round"
        , Svg.Attributes.strokeLinejoin "round"
        ]
        [ Svg.line
            [ Svg.Attributes.x1 "12"
            , Svg.Attributes.y1 "5"
            , Svg.Attributes.x2 "12"
            , Svg.Attributes.y2 "19"
            ]
            []
        , Svg.line
            [ Svg.Attributes.x1 "5"
            , Svg.Attributes.y1 "12"
            , Svg.Attributes.x2 "19"
            , Svg.Attributes.y2 "12"
            ]
            []
        ]


viewName : { name : String, detailUrl : String } -> Html msg
viewName { name, detailUrl } =
    Html.h3
        [ Html.Attributes.class "text-sm font-medium text-gray-500" ]
        [ Html.a
            [ Html.Attributes.href detailUrl ]
            [ Html.text name
            , Html.span
                [ Html.Attributes.class "absolute inset-0 z-10"
                , Html.Attributes.attribute "aria-hidden" "true"
                ]
                []
            ]
        ]


viewPrice : { price : String, valuedAt : Maybe String } -> Html msg
viewPrice { price, valuedAt } =
    Html.div
        [ Html.Attributes.class "text-sm mb-2 flex items-center gap-2" ]
        [ Html.span
            [ Html.Attributes.class "text-gray-600" ]
            [ Html.text price ]
        , valuedAt
            |> Html.Extra.viewMaybe
                (\valuedAt_ ->
                    Html.span
                        [ Html.Attributes.class "text-gray-400" ]
                        [ Html.text ("Valued at " ++ valuedAt_) ]
                )
        ]


viewColorSwatch :
    { all : List Color
    , selected : Color
    , onSelect : Color -> msg
    }
    -> Html msg
viewColorSwatch props =
    Html.div [ Html.Attributes.class "relative z-20 -mx-4 px-4" ]
        [ UI.Swatch.view
            { colors = props.all
            , selectedColor = props.selected
            , onSelectColor = props.onSelect
            }
        ]


viewDescription : String -> Html msg
viewDescription description =
    Html.p
        [ Html.Attributes.class "mt-2 text-gray-500 text-xs" ]
        [ Html.text description ]


boolToInt : Bool -> Int
boolToInt b =
    if b then
        1

    else
        0
