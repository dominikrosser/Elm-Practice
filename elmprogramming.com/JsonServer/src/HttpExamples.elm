module HttpExamples exposing (Model, view, viewNickname)

import Browser
import Html exposing (Html, button, div, h3, li, text, ul)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, decodeString, list, string)



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
    { nicknames : List String
    , errorMessage : Maybe Json.Decode.Error
    , errorString : String
    }


initialModel : Model
initialModel =
    Model [] Nothing ""



-- UPDATE


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error (List String))


url : String
url =
    "http://localhost:5019/nicknames"


nicknamesDecoder : Decoder (List String)
nicknamesDecoder =
    list string


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model, getNicknames )

        DataReceived (Ok nicknames) ->
            ( { model | nicknames = nicknames }, Cmd.none )

        DataReceived (Err _) ->
            ( Model [] Nothing "error on http request", Cmd.none )



-- COMMANDS


initialCmd : Cmd Msg
initialCmd =
    Cmd.none


getNicknames : Cmd Msg
getNicknames =
    Http.get
        { url = url
        , expect = Http.expectJson DataReceived nicknamesDecoder
        }



-- SUBSCRIPTIONS
-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendHttpRequest ]
            [ text "Get data from Server" ]
        , h3 [] [ text "Old school main characters" ]
        , ul [] (List.map viewNickname model.nicknames)
        , text model.errorString
        ]


viewNickname : String -> Html Msg
viewNickname nickname =
    li [] [ text nickname ]
