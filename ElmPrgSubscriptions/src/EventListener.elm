module EventListener exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Browser.Events
import Html exposing (..)
import Json.Decode


-- MODEL


type alias Model =
    Int



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( 0, Cmd.none )



-- UPDATE


type Msg
    = KeyPressed


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyPressed ->
            ( model + 1, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onKeyDown keyDecoder

keyDecoder : Json.Decode.Decoder Msg
keyDecoder =
  Json.Decode.map toKey (Json.Decode.field "key" Json.Decode.string)

toKey : String -> Msg
toKey string =
  KeyPressed

-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text (String.fromInt model) ]



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
