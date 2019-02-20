module DecodingJson exposing (Author, Model, Msg(..), Post, authorDecoder, createErrorMessage, fetchPostsCommand, init, main, postDecoder, postListDecoder, update, view, viewError, viewPost, viewPosts, viewPostsOrError, viewTableHeader)

import Browser
import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, decodeString, field, int, list, map2, map3, string)
import RemoteData exposing (WebData)


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
    { posts : WebData (List Post)
    }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick SendHttpRequest ]
            [ text "Refresh posts" ]
        , viewPostsOrError model
        ]


viewPostsOrError : Model -> Html Msg
viewPostsOrError model =
    case model.posts of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success posts ->
            viewPosts posts

        RemoteData.Failure httpError ->
            viewError (createErrorMessage httpError)


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
    | PostsReceived (WebData (List Post))


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


fetchPostsCommand : Cmd Msg
fetchPostsCommand =
    Http.get
        { url = "http://localhost:5019/posts"
        , expect = Http.expectJson (RemoteData.fromResult >> PostsReceived) (list postDecoder)
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( { model | posts = RemoteData.Loading }, fetchPostsCommand )

        PostsReceived response ->
            ( { model | posts = response }, Cmd.none )


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    "Http Error while getting Data from server"


init : () -> ( Model, Cmd Msg )
init _ =
    ( { posts = RemoteData.Loading }, fetchPostsCommand )


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
