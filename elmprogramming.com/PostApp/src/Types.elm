module Types exposing (Author, Model, Msg(..), Post, Route(..))

import Browser
import Browser.Navigation as Nav
import RemoteData exposing (WebData)
import Url



-- TYPES


type alias Author =
    { name : String
    , url : String
    }


type alias Post =
    { id : Int
    , title : String
    , author : String
    }



-- MODEL


type alias Model =
    { posts : WebData (List Post)
    , key : Nav.Key
    , currentRoute : Route
    }


type Msg
    = FetchPosts
    | PostsReceived (WebData (List Post))
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


type Route
    = PostsRoute
    | PostRoute Int
    | NotFoundRoute
