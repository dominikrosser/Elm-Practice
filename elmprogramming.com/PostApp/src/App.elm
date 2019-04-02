module App exposing (main)

import Browser
import Html
import State exposing (init, update)
import Types exposing (..)
import Views.List exposing (view)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
