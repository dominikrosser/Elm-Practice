module Main exposing (main)

import Browser
import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time



--main


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



--model


type alias Model =
    Time.Posix


init : () -> ( Model, Cmd Msg )
init _ =
    ( Time.millisToPosix 0, Cmd.none )



--update


type Msg
    = Tick Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( newTime, Cmd.none )



--subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1.0 Tick



--view


hourTurns : Time.Posix -> Basics.Float
hourTurns posixTime =
    toFloat (Time.toHour Time.utc posixTime) / 24.0 - 0.25


minuteTurns : Time.Posix -> Basics.Float
minuteTurns posixTime =
    toFloat (Time.toMinute Time.utc posixTime) / 60.0 - 0.25


secondTurns : Time.Posix -> Basics.Float
secondTurns posixTime =
    toFloat (Time.toSecond Time.utc posixTime) / 60.0 - 0.25


secondHand time =
    let
        angle =
            turns (secondTurns time)

        handX =
            String.fromFloat (50.0 + 40.0 * cos angle)

        handY =
            String.fromFloat (50.0 + 40.0 * sin angle)
    in
    line
        [ x1 "50"
        , y1 "50"
        , x2 handX
        , y2 handY
        , stroke "black"
        ]
        []


minuteHand time =
    let
        angle =
            turns (minuteTurns time)

        handX =
            String.fromFloat (50.0 + 33.0 * cos angle)

        handY =
            String.fromFloat (50.0 + 33.0 * sin angle)
    in
    line
        [ x1 "50"
        , y1 "50"
        , x2 handX
        , y2 handY
        , stroke "black"
        , strokeWidth "3px"
        ]
        []


hourHand time =
    let
        angle =
            turns (hourTurns time)

        handX =
            String.fromFloat (50.0 + 25.0 * cos angle)

        handY =
            String.fromFloat (50.0 + 25.0 * sin angle)
    in
    line
        [ x1 "50"
        , y1 "50"
        , x2 handX
        , y2 handY
        , stroke "black"
        , strokeWidth "2px"
        ]
        []


view : Model -> Html Msg
view model =
    svg
        [ viewBox "0 0 100 100"
        , width "300"
        ]
        [ circle
            [ cx "50"
            , cy "50"
            , r "45"
            , fill "red"
            ]
            []
        , secondHand model
        , minuteHand model
        , hourHand model
        ]
