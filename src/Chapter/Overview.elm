module Chapter.Overview exposing (chapter)

import ElmBook.Chapter exposing (Chapter)


chapter : Chapter x
chapter =
    ElmBook.Chapter.chapter "Overview"
        |> ElmBook.Chapter.render
            """
This is a demo "storybook" for the Bellroy [Senior Front End
Developer](https://bellroy.com/careers/senior-front-developer) position coding
exercise.

The component chosen for the exercise is [Product Card](/components/product-card):
![bellroy.com screenshot](https://github.com/throwawaybellroy/bellroy/raw/main/bellroy-com-screenshot.webp).

* The components live in `src/UI` and are written in Elm + TailwindCSS.
* The stories live in `src/Chapter` (plus the main `src/Book.elm` file) and use
  [elm-book](https://elm-book-in-elm-book.netlify.app/overview).


## Philosophy

I have outlined my philosophy on design system API design in the Elm Online
Meetup talk [The Joy of Stateless UI
Components](https://www.youtube.com/watch?v=tmUuHOYKH1Y).

The TL;DR is: use the least power possible; one should rarely reach for a
full-blown stateful TEA module when a single view function will do. This puts
the burden of keeping state on the "page" module, which I have found to be a
good tradeoff.


## Disclaimers

Since this is supposed to be a small exercise according to the instructions,
I've given myself a time limit and made some compromises:

* Due to time constraints, I didn't go for a pixel-perfect match to the
  original design on [bellroy.com](https://bellroy.com), the color theme,
  Tailwind spacing config, the licensed fonts (this being in a public Github repo
  I didn't want to use the font files the Bellroy website uses), etc.
* Similarly, I skipped on accessibility features, responsive design (though I
  know you were interested in that!) and features not easily apparent to a
  visitor but perhaps crucial for SEO etc. It would take more
  reverse-engineering time for me here; without access to your Figma files and
  feature requirements this ended up below my "this is a priority given the
  time constraints" threshold. I'm aware these would need to be handled in a
  real scenario.
* Fetching data from an external source is not implemented, though in an Elm
  setup I'd expect either REST API (-> `Json.Decode`) or GraphQL with a tool
  like [`elm-gql`](https://github.com/vendrinc/elm-gql) that we use at Vendr.
* I skipped on the Astro integration. To be frank I haven't used Astro yet,
  though I'm certain I'd catch up very quickly. I'd rather be honest with you
  that this is something I'd be onboarded on, instead of pretending I'm an
  expert on it already.
"""
