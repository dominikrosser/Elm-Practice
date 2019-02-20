module DecodingJson exposing (Author, Model, Msg(..), Post, authorDecoder, createErrorMessage, httpCommand, init, main, postDecoder, update, view, viewError, viewPost, viewPosts, viewPostsAndMaybeError, viewTableHeader)

import Browser
import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, decodeString, field, int, list, map2, map3, string)


type alias Author =
    { name : String
    , url : String
    }


type alias Post =
    { id : Int
    , title : String
    , author : String
    }


type alias Model =
    { posts : List Post
    , errorMessage : Maybe String
    }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendHttpRequest ]
            [ text "Get data from server" ]
        , viewPostsAndMaybeError model
        ]


viewPostsAndMaybeError : Model -> Html Msg
viewPostsAndMaybeError model =
    div []
        [ viewPosts model.posts
        , case model.errorMessage of
            Just message ->
                viewError message

            Nothing ->
                text ""
        ]


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]


viewPosts : List Post -> Html Msg
viewPosts posts =
    div []
        [ h3 [] [ text "Posts" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewPost posts)
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Title" ]
        , th []
            [ text "Author" ]
        ]


viewPost : Post -> Html Msg
viewPost post =
    tr []
        [ td []
            [ text (String.fromInt post.id) ]
        , td []
            [ text post.title ]
        , td []
            [ text post.author ]
        ]


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error (List Post))


authorDecoder : Decoder Author
authorDecoder =
    map2 Author
        (field "name" string)
        (field "url" string)


postListDecoder : Decoder (List Post)
postListDecoder =
    list postDecoder


postDecoder : Decoder Post
postDecoder =
    map3 Post
        (field "id" int)
        (field "title" string)
        (field "author" string)


httpCommand : Cmd Msg
httpCommand =
    Http.get
        { url = "http://localhost:5019/posts"
        , expect = Http.expectJson DataReceived (list postDecoder)
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model, httpCommand )

        DataReceived (Ok posts) ->
            ( { model
                | posts = posts
                , errorMessage = Nothing
              }
            , Cmd.none
            )

        DataReceived (Err httpError) ->
            ( { model
                | errorMessage = Just (createErrorMessage httpError)
              }
            , Cmd.none
            )


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    "Http Error while getting Data from server"


init : () -> ( Model, Cmd Msg )
init _ =
    ( { posts = []
      , errorMessage = Nothing
      }
    , Cmd.none
    )


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
