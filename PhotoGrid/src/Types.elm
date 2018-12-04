module Types exposing (Comment, Photo, exampleComment, examplePhoto)

import List exposing (repeat)


type alias Photo =
    { url : String
    , username : String
    , location : String
    , likeCount : Int
    , commentCount : Int
    , comments : List Comment
    }


type alias Comment =
    { username : String
    , message : String
    }


examplePhoto : Photo
examplePhoto =
    { url = "image1.png"
    , username = "Dominik"
    , location = "Kandersteg"
    , likeCount = 100
    , commentCount = 20
    , comments = repeat 12 exampleComment
    }


exampleComment =
    { username = "Dominik"
    , message = "Hello World!"
    }
