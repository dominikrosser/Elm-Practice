module Signup exposing (User, init, initialModel, main, update, view)

import Browser
import Html exposing (Attribute, Html, button, div, form, h1, input, text)
import Html.Attributes exposing (id, style, type_)
import Html.Events exposing (onClick, onInput)
import Http


type alias User =
    { name : String
    , email : String
    , password : String
    , loggedIn : Bool
    }


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


view : User -> Html Msg
view user =
    div []
        [ h1 [ headerStyle ]
            [ text "Sign up" ]
        , Html.form formStyles
            [ div []
                [ text "Name"
                , input ([ id "name", type_ "text", onInput SaveName ] ++ inputTextStyles) []
                ]
            , div []
                [ text "Email"
                , input ([ id "email", type_ "email", onInput SaveEmail ] ++ inputTextStyles) []
                ]
            , div []
                [ text "Password"
                , input ([ id "password", type_ "password", onInput SavePassword ] ++ inputTextStyles) []
                ]
            , div []
                [ button
                    ([ type_ "submit", onClick Signup ] ++ buttonStyles)
                    [ text "Create my account" ]
                ]
            ]
        ]


headerStyle : Attribute Msg
headerStyle =
    style "padding-left" "3cm"


formStyles : List (Attribute Msg)
formStyles =
    [ style "border-radius" "5px"
    , style "background-color" "#f2f2f2"
    , style "padding" "20px"
    , style "width" "300px"
    ]


inputTextStyles : List (Attribute Msg)
inputTextStyles =
    [ style "display" "block"
    , style "width" "260px"
    , style "padding" "12px 20px"
    , style "margin" "8px 0"
    , style "border" "none"
    , style "border-radius" "4px"
    ]


buttonStyles : List (Attribute Msg)
buttonStyles =
    [ style "width" "300px"
    , style "background-color" "#397cd5"
    , style "color" "white"
    , style "padding" "14px 20px"
    , style "margin-top" "10px"
    , style "border" "none"
    , style "border-radius" "4px"
    , style "font-size" "16px"
    ]


type Msg
    = SaveName String
    | SaveEmail String
    | SavePassword String
    | Signup


update : Msg -> User -> ( User, Cmd Msg )
update message user =
    case message of
        SaveName name ->
            ( { user | name = name }, Cmd.none )

        SaveEmail email ->
            ( { user | email = email }, Cmd.none )

        SavePassword password ->
            ( { user | password = password }, Cmd.none )

        Signup ->
            ( { user | loggedIn = True }, Cmd.none )


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
