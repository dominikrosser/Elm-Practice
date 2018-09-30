module Main exposing (Model, Msg(..), initialModel, main, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = initialModel, update = update, view = view }



--model


type alias Model =
    { number : Int }


initialModel : Model
initialModel =
    { number = 0 }



--update


type Msg
    = Increment
    | Decrement
    | Multiply
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | number = model.number + 1 }

        Decrement ->
            { model | number = model.number - 1 }

        Multiply ->
            { model | number = model.number ^ 2 }

        Reset ->
            initialModel



--view


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Increment ] [ text "+" ]
        , div [] [ text (String.fromInt model.number) ]
        , div [] []
        , button [ onClick Multiply ] [ text "^2" ]
        , div [] []
        , button [ onClick Decrement ] [ text "-" ]
        , div [] []
        , button [ onClick Reset ] [ text "Reset" ]
        ]
