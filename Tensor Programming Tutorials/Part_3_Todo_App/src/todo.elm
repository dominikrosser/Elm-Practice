module Main exposing (Model, Msg(..), initialModel, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = view
        }



--model


type alias Model =
    { todo : String
    , todos : List String
    }


initialModel : Model
initialModel =
    { todo = ""
    , todos = []
    }



--update


type Msg
    = UpdateTodo String
    | AddTodo
    | RemoveAll
    | RemoveItem String
    | ClearInput


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateTodo text ->
            { model | todo = text }

        AddTodo ->
            { model | todos = model.todo :: model.todos }

        RemoveAll ->
            initialModel

        RemoveItem text ->
            { model | todos = List.filter (\x -> x /= text) model.todos }

        ClearInput ->
            { model | todo = "" }



--view


stylesheet =
    let
        tag =
            "link"

        attrs =
            [ attribute "Rel" "stylesheet"
            , attribute "property" "stylesheet"
            , attribute "href" "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
            ]

        children =
            []
    in
    node tag attrs children


todoItem : String -> Html Msg
todoItem todo =
    li [] [ text todo, button [ onClick (RemoveItem todo) ] [ text "x" ] ]


todoList : List String -> Html Msg
todoList todos =
    let
        child =
            List.map todoItem todos
    in
    ul [] child


view : Model -> Html Msg
view model =
    div [ class "jumbotron" ]
        [ stylesheet
        , input
            [ type_ "text"
            , onInput UpdateTodo
            , value model.todo
            , class "form-control"
            , onMouseEnter ClearInput
            ]
            []
        , button [ onClick AddTodo, class "btn btn-primary" ] [ text "Submit" ]
        , button [ onClick RemoveAll, class "btn btn-danger" ] [ text "Remove All" ]
        , div [] [ todoList model.todos ]
        ]
