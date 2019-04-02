module State exposing (init, initialModel, update)

import Browser
import Browser.Navigation as Nav
import RemoteData exposing (WebData)
import Rest exposing (fetchPostsCommand)
import Routing
import Types exposing (..)
import Url


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( initialModel url key, fetchPostsCommand )


initialModel : Url.Url -> Nav.Key -> Model
initialModel url key =
    { posts = RemoteData.Loading
    , key = key
    , currentRoute = Routing.extractRoute url
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | currentRoute = Routing.extractRoute url }
            , Cmd.none
            )

        FetchPosts ->
            ( { model | posts = RemoteData.Loading }, fetchPostsCommand )

        PostsReceived response ->
            ( { model | posts = response }, Cmd.none )
