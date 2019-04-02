module Types exposing (Author, Model, Msg(..), Post)

import RemoteData exposing (WebData)



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
    }


type Msg
    = FetchPosts
    | PostsReceived (WebData (List Post))
