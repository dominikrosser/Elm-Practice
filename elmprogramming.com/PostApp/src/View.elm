module View exposing (findPostById, notFoundView, view)

import Html exposing (Html, h3, text)
import RemoteData exposing (WebData)
import Types exposing (..)
import Views.Edit
import Views.List


view : Model -> Html Msg
view model =
    case model.currentRoute of
        PostsRoute ->
            Views.List.view model

        PostRoute id ->
            case findPostById id model.posts of
                Just post ->
                    Views.Edit.view post

                Nothing ->
                    notFoundView

        NotFoundRoute ->
            notFoundView


findPostById : Int -> WebData (List Post) -> Maybe Post
findPostById postId maybePosts =
    case RemoteData.toMaybe maybePosts of
        Just posts ->
            posts
                |> List.filter (\post -> post.id == postId)
                |> List.head

        Nothing ->
            Nothing


notFoundView : Html Msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]
