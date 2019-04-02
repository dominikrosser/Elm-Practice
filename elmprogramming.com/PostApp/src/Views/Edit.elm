module Views.Edit exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)


view : Post -> Html Msg
view post =
    div []
        [ h3 [] [ text "Edit Post" ]
        , editForm post
        ]


editForm : Post -> Html Msg
editForm post =
    form []
        [ div []
            [ text "Title"
            , br [] []
            , input
                [ type_ "text"
                , value pos.title
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author Name"
            , br [] []
            , input
                [ type_ "text"
                , value post.author.name
                ]
                []
            ]
        , br [] []
        , div []
            [ button []
                [ text "Submit" ]
            ]
        ]
