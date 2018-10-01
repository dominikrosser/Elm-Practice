--- Snake moves in a direction
--- Snake has a body
--- Snake eats apple it grows
--- hit key Snake moves in a different direction
--- We can't hit opposite key
--- failstate : snake hits itself : snake hits wall
--- Window : grid
--- Apple : Random Random X and Random Y and Random Chance to spawn


module Main exposing (main)

import Browser
import Browser.Dom
import Browser.Events
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



--model


type alias Game =
    { direction : Direction
    , dimensions : Maybe Browser.Dom.Viewport
    , snake : Snake
    , isDead : Bool
    , apple : Maybe Block
    , ateApple : Bool
    }


type alias Block =
    { x : Int
    , y : Int
    }


type alias Snake =
    List Block


type Direction
    = Up
    | Down
    | Left
    | Right


type Keys
    = NoKey
    | LeftKey
    | RightKey
    | UpKey
    | DownKey


type alias AppleSpawn =
    { position : ( Int, Int )
    , chance : Int
    }


initSnake : Snake
initSnake =
    [ Block 25 25
    , Block 24 25
    , Block 23 25
    ]


init : () -> ( Game, Cmd Msg )
init _ =
    ( { direction = Right
      , snake = initSnake
      , isDead = False
      , apple = Nothing
      , ateApple = False
      , dimensions = Nothing
      }
    , initCmds
    )



--update


type Msg
    = ArrowPressed Keys
    | SizeUpdated Int Int
    | Tick Time.Posix
    | MaybeSpawnApple AppleSpawn
    | InitViewport Browser.Dom.Viewport


update : Msg -> Game -> ( Game, Cmd Msg )
update msg game =
    case msg of
        ArrowPressed arrow ->
            ( updateDirection arrow game, Cmd.none )

        Tick posixTime ->
            updateGame game

        MaybeSpawnApple spawn ->
            if spawn.chance == 0 then
                ( spawnApple game spawn, Cmd.none )

            else
                ( game, Cmd.none )

        InitViewport viewSize ->
            ( { game | dimensions = Just viewSize }, Cmd.none )

        SizeUpdated _ _ ->
            ( game, initCmds )


updateGame : Game -> ( Game, Cmd Msg )
updateGame game =
    if game.isDead then
        ( game, Cmd.none )

    else
        ( game, Cmd.none )
            |> checkIfOutOfBounds
            |> checkIfEatenSelf
            |> checkIfAteApple
            |> updateSnake
            |> updateApple


spawnApple : Game -> AppleSpawn -> Game
spawnApple game spawn =
    let
        ( x, y ) =
            spawn.position
    in
    { game | apple = Just { x = x, y = y } }


checkIfEatenSelf : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
checkIfEatenSelf ( game, cmd ) =
    let
        head =
            snakeHead game.snake

        tail =
            List.drop 1 game.snake

        isDead =
            game.isDead || List.any (samePosition head) tail
    in
    ( { game | isDead = isDead }, cmd )


checkIfAteApple : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
checkIfAteApple ( game, cmd ) =
    let
        head =
            snakeHead game.snake
    in
    case game.apple of
        Nothing ->
            ( { game | ateApple = False }, cmd )

        Just apple ->
            ( { game | ateApple = samePosition head apple }, cmd )


samePosition : Block -> Block -> Bool
samePosition a b =
    a.x == b.x && a.y == b.y


checkIfOutOfBounds : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
checkIfOutOfBounds ( game, cmd ) =
    let
        head =
            snakeHead game.snake

        isDead =
            (head.x == 0 && game.direction == Left)
                || (head.y == 0 && game.direction == Up)
                || (head.x == 49 && game.direction == Right)
                || (head.y == 49 && game.direction == Down)
    in
    ( { game | isDead = isDead }, cmd )


snakeHead : Snake -> Block
snakeHead snake =
    List.head snake
        |> Maybe.withDefault { x = 0, y = 0 }


updateApple : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
updateApple ( game, cmd ) =
    case game.apple of
        Nothing ->
            let
                chance =
                    Random.int 0 9

                x =
                    Random.int 0 49

                y =
                    Random.int 0 49

                pos =
                    Random.pair x y
            in
            ( game, Random.generate MaybeSpawnApple makeAppleSpawnGenerator )

        Just apple ->
            if game.ateApple then
                ( { game | apple = Nothing }, cmd )

            else
                ( game, cmd )


makeAppleSpawnGenerator : Random.Generator AppleSpawn
makeAppleSpawnGenerator =
    let
        spawnPosition =
            Random.pair (Random.int 0 49) (Random.int 0 49)

        spawnChance =
            Random.int 0 9
    in
    Random.map2 (\pos chance -> { position = pos, chance = chance }) spawnPosition spawnChance


updateSnake : ( Game, Cmd Msg ) -> ( Game, Cmd Msg )
updateSnake ( game, cmd ) =
    let
        head =
            snakeHead game.snake

        head_ =
            case game.direction of
                Up ->
                    { head | y = head.y - 1 }

                Down ->
                    { head | y = head.y + 1 }

                Left ->
                    { head | x = head.x - 1 }

                Right ->
                    { head | x = head.x + 1 }

        tailPositions =
            if game.ateApple then
                game.snake

            else
                List.take (List.length game.snake - 1) game.snake

        tailXs =
            List.map .x tailPositions

        tailYs =
            List.map .y tailPositions

        tail_ =
            List.map2 Block tailXs tailYs
    in
    if game.isDead then
        ( game, cmd )

    else
        ( { game | snake = head_ :: tail_ }, cmd )


updateDirection : Keys -> Game -> Game
updateDirection key game =
    let
        direction =
            game.direction

        direction_ =
            if key == LeftKey && direction /= Right then
                Left

            else if key == RightKey && direction /= Left then
                Right

            else if key == UpKey && direction /= Down then
                Up

            else if key == DownKey && direction /= Up then
                Down

            else
                direction
    in
    { game | direction = direction_ }



--subscriptions


subscriptions : Game -> Sub Msg
subscriptions game =
    Sub.batch [ arrowChanged, windowDimensionsChanged, tick ]


initCmds : Cmd Msg
initCmds =
    Task.perform InitViewport Browser.Dom.getViewport


windowDimensionsChanged : Sub Msg
windowDimensionsChanged =
    Browser.Events.onResize SizeUpdated


tick : Sub Msg
tick =
    Time.every 100 Tick


arrowChanged : Sub Msg
arrowChanged =
    Browser.Events.onKeyDown keyDecoder


keyDecoder : Json.Decode.Decoder Msg
keyDecoder =
    Json.Decode.map toKey (Json.Decode.field "key" Json.Decode.string)


toKey : String -> Msg
toKey string =
    case string of
        "ArrowLeft" ->
            ArrowPressed LeftKey

        "ArrowRight" ->
            ArrowPressed RightKey

        "ArrowUp" ->
            ArrowPressed UpKey

        "ArrowDown" ->
            ArrowPressed DownKey

        _ ->
            ArrowPressed NoKey



--view


size : String
size =
    "100"


backgroundColor : Svg.Attribute Msg
backgroundColor =
    Svg.Attributes.fill "#c1c1c1"


nullViewport : Browser.Dom.Viewport
nullViewport =
    { scene = { width = 0, height = 0 }
    , viewport = { x = 0, y = 0, width = 0, height = 0 }
    }


view : Game -> Html.Html Msg
view game =
    let
        ( scaledWidth, scaledHeight ) =
            scale (game.dimensions |> Maybe.withDefault nullViewport)
    in
    Svg.svg
        [ Svg.Attributes.width scaledWidth
        , Svg.Attributes.height scaledHeight
        , Html.Attributes.style "margin" "0 auto"
        , Html.Attributes.style "display" "block"
        , viewBox "0 0 50 50"
        ]
        ([ renderBackground ] ++ renderSnake game.snake ++ renderApple game.apple)


renderBackground : Svg.Svg Msg
renderBackground =
    Svg.rect
        [ Svg.Attributes.x "0"
        , Svg.Attributes.y "0"
        , Svg.Attributes.width size
        , Svg.Attributes.height size
        , backgroundColor
        ]
        []


renderSnake : Snake -> List (Svg.Svg Msg)
renderSnake snake =
    List.map renderBlock snake


renderBlock : Block -> Svg.Svg Msg
renderBlock block =
    let
        ( strX, strY ) =
            ( String.fromInt block.x, String.fromInt block.y )
    in
    Svg.rect
        [ Svg.Attributes.x strX
        , Svg.Attributes.y strY
        , Svg.Attributes.width "1"
        , Svg.Attributes.height "1"
        , Svg.Attributes.fill "#44e241"
        , Svg.Attributes.rx "0.2"
        ]
        []


renderApple : Maybe Block -> List (Svg.Svg Msg)
renderApple apple =
    case apple of
        Just block ->
            [ renderBlock block ]

        Nothing ->
            []


scale : Browser.Dom.Viewport -> ( String, String )
scale viewportSize =
    let
        toPixelStr =
            \i -> round i |> String.fromInt

        ( fWidth, fHeight ) =
            ( viewportSize.scene.width, viewportSize.scene.height )

        ( scaledX, scaledY ) =
            if fWidth > fHeight then
                ( fHeight / fWidth, 1.0 )

            else
                ( 1.0, fWidth / fHeight )
    in
    ( toPixelStr (fWidth * scaledX), toPixelStr (fHeight * scaledY) )
