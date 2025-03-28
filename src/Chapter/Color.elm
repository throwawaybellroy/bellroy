module Chapter.Color exposing (chapter)

import ElmBook.Chapter exposing (Chapter)


chapter : Chapter x
chapter =
    ElmBook.Chapter.chapter "Color"
        |> ElmBook.Chapter.render
            """
Colors are a type used by multiple components - they can be thought of as "patterns" or "variants" for products.

```elm
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
