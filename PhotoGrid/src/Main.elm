module Main exposing (Model, Msg(..), initialModel)

import Browser
import Html exposing (Html, div, img, span, text)
import Html.Attributes exposing (class, height, src, width)
import Html.Events exposing (onClick)
import List exposing (append, drop, length, map, repeat, take)
import PhotoView exposing (Comment, Photo, examplePhoto)
import String


type Msg
    = OpenPhoto Photo
    | ClosePhoto


type alias Model =
    { name : String
    , photoCount : Int
    , photos : List Photo
    , photoOpened : Maybe Photo
    , newComment : String
    }


initialModel =
    { name = "#lateNightCoding"
    , photoCount = 123456789
    , photos = repeat 8 PhotoView.examplePhoto
    , photoOpened = Nothing
    , newComment = ""
    }


view : Model -> Html Msg
view model =
    let
        body =
            [ profileInfo model.name model.photoCount
            , photoGrid model.photos
            ]
    in
    case model.photoOpened of
        Just photoOpened ->
            photoOpened
                |> photoView model.newComment
                |> repeat 1
                |> append body
                |> div []

        Nothing ->
            div [] body


photoView : String -> Photo -> Html Msg
photoView newComment photoOpened =
    let
        model =
            { photo = photoOpened
            , newComment = newComment
            , showCloseButton = True
            }
    in
    model
        |> PhotoView.view
        |> Html.map (\_ -> ClosePhoto)


photoGrid : List Photo -> Html Msg
photoGrid photos =
    photos |> map photoItem |> div [ class "photo-grid" ]


photoItem : Photo -> Html Msg
photoItem photo =
    div [ class "photo" ]
        [ img
            [ src photo.url
            , width 300
            , height 300
            , onClick (OpenPhoto photo)
            ]
            []
        ]


profileInfo : String -> Int -> Html Msg
profileInfo name photoCount =
    div [ class "profile-info" ]
        [ div [ class "name" ]
            [ text name ]
        , div [ class "count" ]
            [ span [ class "value" ]
                [ photoCount |> String.fromInt |> text ]
            , text " posts"
            ]
        ]
