module Routing exposing (extractRoute, matchRoute)

import Types exposing (..)
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, top)


extractRoute : Url.Url -> Route
extractRoute url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map PostsRoute top
        , map PostsRoute (s "posts")
        , map PostRoute (s "posts" </> int)
        ]
