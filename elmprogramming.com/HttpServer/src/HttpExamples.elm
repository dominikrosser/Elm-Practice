module HttpExamples exposing (Model, view, viewNickname)

import Browser
import Html exposing (Html, button, div, h3, li, text, ul)
import Html.Events exposing (onClick)
import Http



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, initialCmd )



-- MODEL


type alias Model =
    List String


initialModel : Model
initialModel =
    []



-- UPDATE


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error String)


url : String
url =
    "http://localhost:5016/old-school.txt"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model, getNicknames )

        DataReceived (Ok nicknamesStr) ->
            let
                nicknames =
                    String.split "," nicknamesStr
            in
            ( model ++ nicknames, Cmd.none )

        DataReceived (Err _) ->
            ( model ++ [ "Error" ], Cmd.none )



-- COMMANDS


initialCmd : Cmd Msg
initialCmd =
    Cmd.none


getNicknames : Cmd Msg
getNicknames =
    Http.get
        { url = url
        , expect = Http.expectString DataReceived
        }



-- SUBSCRIPTIONS
-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendHttpRequest ]
            [ text "Get data from Server" ]
        , h3 [] [ text "Old school main characters" ]
        , ul [] (List.map viewNickname model)
        ]


viewNickname : String -> Html Msg
viewNickname nickname =
    li [] [ text nickname ]
