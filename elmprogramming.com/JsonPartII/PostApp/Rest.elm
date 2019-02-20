module Rest exposing (fetchPostsCommand)

import Http
import Json.Decode exposing (Decoder, field, int, list, map2, map3, string)
import RemoteData
import Types exposing (..)



-- DECODERS


authorDecoder : Decoder Author
authorDecoder =
    map2 Author
        (field "name" string)
        (field "url" string)


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
