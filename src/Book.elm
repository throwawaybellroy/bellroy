module Book exposing (State, main)

import Chapter.Color
import Chapter.Overview
import Chapter.ProductCard
import Chapter.Swatch
import ElmBook exposing (Book)
import ElmBook.StatefulOptions
import ElmBook.ThemeOptions
import Html


type alias State =
    { swatch : Chapter.Swatch.State
    , productCard : Chapter.ProductCard.State
    }


init : State
init =
    { swatch = Chapter.Swatch.init
    , productCard = Chapter.ProductCard.init
    }


main : Book State
main =
    ElmBook.book "Book"
        |> ElmBook.withStatefulOptions
            [ ElmBook.StatefulOptions.initialState init ]
        |> ElmBook.withThemeOptions
            [ ElmBook.ThemeOptions.globals
                [ Html.node "style" [] [ Html.text """
.elm-book__chapter-component__content {
  border: none !important;
}
code {
  font-size: 14px !important;
  line-height: 1.2 !important;
}
""" ] ]
            ]
        |> ElmBook.withChapterGroups
            [ ( "General"
              , [ Chapter.Overview.chapter
                ]
              )
            , ( "Types"
              , [ Chapter.Color.chapter
                ]
              )
            , ( "Components"
              , [ Chapter.Swatch.chapter
                , Chapter.ProductCard.chapter
                ]
              )
            ]
