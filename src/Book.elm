module Book exposing (State, main)

import Chapter.Color
import Chapter.Overview
import Chapter.ProductCard
import Chapter.Swatch
import ElmBook exposing (Book)
import ElmBook.StatefulOptions


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
