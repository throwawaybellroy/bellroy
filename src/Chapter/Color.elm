module Chapter.Color exposing (chapter)

import ElmBook.Chapter exposing (Chapter)
import Html
import Html.Attributes
import UI.Color


nightsky : UI.Color.Color
nightsky =
    { slug = "nightsky"
    , name = "Nightsky"
    , type_ = UI.Color.color "rgb(33, 46, 65)"
    }


arcadeGray : UI.Color.Color
arcadeGray =
    { slug = "arcade-gray"
    , name = "Arcade Gray"
    , type_ =
        UI.Color.img
            { url = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAIAAABLixI0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAylpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMC1jMDAxIDc5LjE0ZWNiNDJmMmMsIDIwMjMvMDEvMTMtMTI6MjU6NDQgICAgICAgICI+IDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+IDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bXA6Q3JlYXRvclRvb2w9IkFkb2JlIFBob3Rvc2hvcCAyNC4yIChNYWNpbnRvc2gpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjE1RjY3NThGRkYyNjExRURBREFGRUQ4RTU3MEFGODYxIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjE1RjY3NTkwRkYyNjExRURBREFGRUQ4RTU3MEFGODYxIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MTVGNjc1OERGRjI2MTFFREFEQUZFRDhFNTcwQUY4NjEiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MTVGNjc1OEVGRjI2MTFFREFEQUZFRDhFNTcwQUY4NjEiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz5nohuYAAADz0lEQVR42sxVXU8bRxT17s7Mru0FisGSqYn52LVDsATUQPrQnxAlD00tVUJB4QmV/9N8PBUlEqoUqb+gUNqqT8VAKxUREqmsTRpTU4SEbbwf9vbsjj3hB/CQsWTduTN3Zu45596Vctn88qOlY8va+X1X1VgkHN+srT598pzbdstZWCyYpvHy5Yaux+FpNBpra6s/bm5bxxYhiu/7fX19XxUfkkfLSzOzM5nxjGmaWODxExPjxeJDbnte+9P0yFAisbT0NWPBZY7r5HJZQunFxYUsyX7EV5mazZoEZ4+PZWq1WqVcIZTw+On8nUrlpHuW61GGWxTLqmiaGrzUtu9MTb1/Xz2rnclycFZUi2bGbpGdnRJeVC6X93b3VVXl8Yt3F/7Y/7Obo21jN36l0q4eD3NsNgqFudevj8pWBXd0ghx1M2sQxONSSikMpnbxwm3CxsCqoihig9f2MA1DGAzghdxhyJGbGzd5lrS+/gKsgebz/85lpcsjSHnz5i23O+12YijRp+t/BwogIbNeLmtWT08bjaYkSRHfB6eZzC3p87tfgH6wBrAFRo9Xlte/e8Ftx3Zm52Zw36tXP8TjMXiazebKyvIvv/52UjnheOm6fv/BvY8VLwL5QNmu68IQ3k6ng9SEvrDabrdh0BAvGJiGIQ7XF2MOPGRhYT6dHoGypYgkdJ9IDAIjoftJc2IklZqfLwjdJ5PJ27dzKCyh+2RymKBoE3CBQT+i9HgElgCb27gwlUoNDg4a5iSjFB68aGCgf3Q0DbmLeuzv7yeofhStZZV3S3usV0MQAVjr8WgX5j8zDGNj4/t4WEPNZgOnbP30c9kqKwoJ+4SuQC9oI6gATdOwT2gCfk5/UECEYJUxGg9G4ISkUEDRaBRzrolYLEYpuVEeoXjHce2WDRGjaHs9y4MgRS/EKjDCTryI90IQ0mq1sIe/C/8IkZ58+wyN7fLyslY7E6U+nZ8++Ough30HHAHso6O3NCTa9bx8fvrdu38QJUuSHzYSw5gkm5tbQKdarR4eHlFGefzQ8BBKhNuu405N5dKj6a2t7WgsCk/r6uqTgYGd0t5ptRoKIMALmJLjYwuttvbvGRqb6PfI96TXV5EjdASVgGvR7+uXdVx/vR7r9TreRKA3WZGDNtzTF6pf2PBjFYOEOzjLkhxs4IPjhZBAHdeHIEXYwn/dENPrgQSfIzRfiAV6o+yDvvDsLl7MwSo0iJ2xEC/eoKG1QPcyzzEODykWv0Tnw1cEzV/khcaGfiRqCDyiRJTwsxBWqDtpTKiaBtSQLF5IKUPN/S/AAPRO7JOQRZjnAAAAAElFTkSuQmCC"
            , borderColor = "rgb(91, 91, 88)"
            }
    }


bronze : UI.Color.Color
bronze =
    { slug = "bronze"
    , name = "Bronze"
    , type_ = UI.Color.color "rgb(180, 86, 40)"
    }


viewColor : UI.Color.Color -> Html.Html msg
viewColor color =
    Html.div
        [ Html.Attributes.class "w-8 h-8 rounded border-4"
        , UI.Color.bgStyle color.type_
        , UI.Color.borderStyle color.type_
        ]
        []


chapter : Chapter x
chapter =
    ElmBook.Chapter.chapter "Color"
        |> ElmBook.Chapter.withComponent
            (Html.div [ Html.Attributes.class "flex gap-4" ]
                [ viewColor nightsky
                , viewColor arcadeGray
                , viewColor bronze
                ]
            )
        |> ElmBook.Chapter.render
            """
<component />

Colors are a type used by multiple components - they can be thought of as "patterns" or "variants" for products.

```elm
module UI.Color

type alias Color =
    { slug : String
    , name : String
    , type_ : Type
    }

color : String -> Type
img   : { url : String, borderColor : String } -> Type

bgStyle     : Type -> Html.Attribute msg
borderStyle : Type -> Html.Attribute msg
```

An example would be "Nightsky" which corresponds to `rgb(33, 46, 65)`, or "Arcade Gray" which corresponds to a square grid pattern: 

```elm
nightsky : Color
nightsky =
    { slug = "nightsky"
    , name = "Nightsky"
    , type_ = color "rgb(33, 46, 65)"
    }

arcadeGray : Color
arcadeGray =
    { slug = "arcade-gray"
    , name = "Arcade Gray"
    , type_ =
        img
            { url = "url(\\"data:image/png;base64,iVB...snip...mCC\\")"
            , borderColor = "rgb(91, 91, 88)"
            }
    }
```

The `bgStyle` function can later be used to render the color into a `background-color` or `background-image` CSS style.
Similarly, the `borderStyle` function can be used to render the color into a `border-color` CSS style.

Check out the [Swatch](/components/swatch) chapter for an example of how Colors can be used.
"""
