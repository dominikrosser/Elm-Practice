module Main exposing (Calculator, Model, Msg(..), appendDecimal, calculate, calculator, calculatorButton, calculatorButtonWide, decimal, equal, init, main, operation, parseFloat, stylesheet, update, updateDisplay, view, zero)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



-- MODEL


type alias Calculator =
    { add : Float -> Float -> Float
    , minus : Float -> Float -> Float
    , times : Float -> Float -> Float
    , divide : Float -> Float -> Float
    }


calculator : Calculator
calculator =
    { add = \x y -> x + y
    , minus = \x y -> x - y
    , times = \x y -> x * y
    , divide = \x y -> x / y
    }


type alias Model =
    { display : String
    , function : Float -> Float -> Float
    , saveValue : Float
    , append : Bool
    }


parseFloat : String -> Float
parseFloat input =
    Maybe.withDefault 0.0 (String.toFloat input)


operation : Model -> (Float -> Float -> Float) -> Model
operation model function =
    { model
        | function = function
        , saveValue = parseFloat model.display
        , append = False
    }



-- INIT


init =
    { display = ""
    , function = \x y -> y
    , saveValue = 0
    , append = True
    }



-- UPDATE


type Msg
    = None
    | Divide
    | Times
    | Minus
    | Add
    | Equal
    | Decimal
    | Zero
    | Number Int
    | Clear


update : Msg -> Model -> Model
update msg model =
    case msg of
        None ->
            model

        Clear ->
            init

        Number number ->
            updateDisplay model number

        Decimal ->
            decimal model

        Zero ->
            zero model

        Divide ->
            operation model calculator.divide

        Times ->
            operation model calculator.times

        Add ->
            operation model calculator.add

        Minus ->
            operation model calculator.minus

        Equal ->
            equal model


updateDisplay : Model -> Int -> Model
updateDisplay model number =
    if model.append then
        { model
            | display = model.display ++ String.fromInt number
        }

    else
        { model
            | display = number |> String.fromInt
            , append = True
        }


equal : Model -> Model
equal model =
    if model.append then
        { model
            | display = calculate model
            , saveValue = model.display |> parseFloat
            , append = False
        }

    else
        { model
            | display = calculate model
            , append = False
        }


calculate : Model -> String
calculate model =
    model.function model.saveValue (parseFloat model.display) |> String.fromFloat


zero : Model -> Model
zero model =
    if String.isEmpty model.display || not model.append then
        { model
            | display = "0"
            , append = False
        }

    else
        { model
            | display = model.display ++ "0"
        }


decimal : Model -> Model
decimal model =
    if not (String.isEmpty model.display) && model.append then
        { model
            | display = appendDecimal model.display
        }

    else
        { model
            | display = "0."
            , append = True
        }


appendDecimal : String -> String
appendDecimal string =
    if String.contains "." string then
        string

    else
        string ++ "."



-- VIEW


calculatorButton : Msg -> String -> Html Msg
calculatorButton msg buttonText =
    button
        [ class "button"
        , onClick msg
        ]
        [ span [] [ text buttonText ] ]


calculatorButtonWide : Msg -> String -> Html Msg
calculatorButtonWide msg buttonText =
    button
        [ class "button wide"
        , onClick msg
        ]
        [ span [] [ text buttonText ] ]


stylesheet : Html a
stylesheet =
    let
        tag =
            "link"

        attrs =
            [ attribute "rel" "stylesheet"
            , attribute "property" "stylesheet"
            , attribute "href" "styles.css"
            ]

        child =
            []
    in
    node tag attrs child


view : Model -> Html Msg
view model =
    div [ class "calculator" ]
        [ stylesheet
        , div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "display" ]
                    [ div [ class "display-text" ]
                        [ text model.display ]
                    ]
                , div [ class "buttons" ]
                    [ calculatorButtonWide Clear "Clear"
                    , calculatorButton (Number 7) "7"
                    , calculatorButton (Number 8) "8"
                    , calculatorButton (Number 9) "9"
                    , calculatorButton Divide "/"
                    , calculatorButton (Number 4) "4"
                    , calculatorButton (Number 5) "5"
                    , calculatorButton (Number 6) "6"
                    , calculatorButton Times "*"
                    , calculatorButton (Number 1) "1"
                    , calculatorButton (Number 2) "2"
                    , calculatorButton (Number 3) "3"
                    , calculatorButton Minus "-"
                    , calculatorButton Zero "0"
                    , calculatorButton Decimal "."
                    , calculatorButton Equal "="
                    , calculatorButton Add "+"
                    ]
                ]
            ]
        ]



-- MAIN


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
