module Signup exposing (User, init, initialModel, main, update, view)

import Browser
import Html exposing (Html, button, div, form, h1, input, text)
import Html.Attributes exposing (id, type_, style)
import Http


type alias User =
    { name : String
    , email : String
    , password : String
    , loggedIn : Bool
    }


type Msg
    = Nothing


initialModel : User
initialModel =
    { name = ""
    , email = ""
    , password = ""
    , loggedIn = False
    }


init : () -> ( User, Cmd Msg )
init _ =
    ( initialModel
    , Cmd.none
    )


view : User -> Html msg
view user =
    div []
        [ h1 [ Html.Attributes.style "padding-left" "3cm" ]
             [ text "Sign up" ] 
        , Html.form []
            [ div []
                [ text "Name"
                , input
                    [ id "name"
                    , type_ "text"
                    ]
                    []
                ]
            , div []
                [ text "Email"
                , input
                    [ id "email"
                    , type_ "email"
                    ]
                    []
                ]
            , div []
                [ text "Password"
                , input
                    [ id "password"
                    , type_ "password"
                    ]
                    []
                ]
            , div []
                [ button
                    [ type_ "submit" ]
                    [ text "Create my account" ]
                ]
            ]
        ]

headerStyle : Attribute msg
headerStyle =
  style "padding-left" "3cm"

formStyle : Attribute msg
formStyle =
  style "todo" "todo"

update : msg -> User -> ( User, Cmd Msg )
update msg model =
    ( initialModel, Cmd.none )


subscriptions : User -> Sub Msg
subscriptions _ =
    Sub.none


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
