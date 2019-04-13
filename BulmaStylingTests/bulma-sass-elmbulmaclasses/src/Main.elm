module Main exposing (view)

import Bulma.Classes as Bulma
import Html exposing (div, text)
import Html.Attributes exposing (class)


view =
    div [ class Bulma.columns ]
        [ div [ class Bulma.column ]
            [ text "column 1" ]
        , div [ class Bulma.column ]
            [ text "column 2" ]
        ]
