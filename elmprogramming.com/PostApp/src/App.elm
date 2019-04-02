module App exposing (main)

import Browser
import Browser.Navigation as Nav
import Html
import State exposing (init, update)
import Types exposing (..)
import View


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


view : Model -> Browser.Document Msg
view model =
    { title = "App"
    , body =
        [ View.view model ]
    }
