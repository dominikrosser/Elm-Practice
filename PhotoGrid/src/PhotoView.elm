module PhotoView exposing (Comment, Photo, examplePhoto, view)

import Browser
import Html exposing (Html, div, img, text)
import Html.Attributes exposing (class, src, type_)
import Html.Events exposing (onClick)
import List exposing (append, map, repeat, reverse)
import String


type Msg
    = LikePhoto
    | SubmitComment String
    | CloseModal


type alias Comment =
    { user : String
    , message : String
    }


type alias Photo =
    { user : String
    , location : String
    , likesCount : Int
    , commentsCount : Int
    , comments : List Comment
    , url : String
    }


examplePhoto : Photo
examplePhoto =
    { url = "image1.png"
    , user = "Dominik"
    , location = "Kandersteg"
    , likesCount = 100
    , commentsCount = 20
    , comments = repeat 12 exampleComment
    }


exampleComment : Comment
exampleComment =
    { user = "Dominik", message = "Hallo Welt!" }


type alias Model =
    { photo : Photo
    , newComment : String
    , showCloseButton : Bool
    }


initialModel =
    Model examplePhoto "" True


view : Model -> Html Msg
view model =
    let
        photoHtml =
            photo model.photo.url

        sidebarHtml =
            sidebar model.photo

        html =
            case model.showCloseButton of
                True ->
                    [ photoHtml, sidebarHtml, closeButton ]

                False ->
                    [ photoHtml, sidebarHtml ]
    in
    div [ class "photo-view" ] html


update : Msg -> Model -> Model
update msg model =
    case msg of
        LikePhoto ->
            model

        SubmitComment newComment ->
            { model | newComment = "" }

        CloseModal ->
            model


photo : String -> Html Msg
photo photoUrl =
    img [ class "photo", src photoUrl ] []


sidebar : Photo -> Html Msg
sidebar photo_ =
    div [ class "sidebar" ]
        [ sidebarTop photo_.user photo_.location
        , sidebarCount photo_.likesCount photo_.commentsCount
        , sidebarComments photo_.commentsCount photo_.comments
        ]


closeButton : Html Msg
closeButton =
    div [ class "close-button", onClick CloseModal ]
        [ text "X" ]


followButton : Html Msg
followButton =
    div [ class "follow-button" ]
        [ text "Follow" ]


likeButton : Html Msg
likeButton =
    div [ class "like-button", onClick LikePhoto ]
        [ text "Like this Photo" ]


sidebarTop : String -> String -> Html Msg
sidebarTop user location =
    div [ class "sidebar-top" ]
        [ div [ class "photo-info" ]
            [ div [ class "user" ] [ text user ]
            , div [ class "location" ] [ text location ]
            ]
        , div [ class "photo-actions" ] [ text "Placeholder" ]
        ]


sidebarCount : Int -> Int -> Html Msg
sidebarCount likesCount commentsCount =
    let
        likesCountStr =
            String.fromInt likesCount

        commentsCountStr =
            String.fromInt commentsCount
    in
    div []
        [ text likesCountStr
        , text " likes, "
        , text commentsCountStr
        , text " comments"
        ]


sidebarComments : Int -> List Comment -> Html Msg
sidebarComments commentsCount comments =
    let
        pageSize =
            10

        pages =
            commentsCount // pageSize

        commentsList =
            comments
                |> map displayComment
                |> div [ class "comments-list" ]

        loadMoreItems =
            div [ class "load-more-comments" ]
                [ text "Load more Comments" ]

        container =
            if pages == 1 then
                [ commentsList ]

            else
                [ commentsList, loadMoreItems ]
    in
    div [ class "comments-container" ] container


displayComment : Comment -> Html Msg
displayComment comment =
    div [ class "comment" ]
        [ div [ class "user" ] [ text comment.user ]
        , div [ class "message" ] [ text comment.message ]
        ]


main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = view
        }
