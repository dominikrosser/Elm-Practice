module PhotoGrid exposing (Model, Msg(..), initialModel, main, photoGridView, photoView, update, view)

import Browser
import Html exposing (Html, div, img, text)
import Html.Attributes exposing (class, src)
import List exposing (map, repeat)
import Types exposing (Comment, Photo, examplePhoto)


type Msg
    = Nothing


type alias Model =
    { photos : List Photo
    }


initialModel : Model
initialModel =
    { photos = repeat 12 examplePhoto }


update msg model =
    model


photoView : Photo -> Html Msg
photoView photo =
    div [ class "photo" ]
        [ img [ src "image1.jpg" ] [] ]


photoGridView : List Photo -> Html Msg
photoGridView photos =
    div [ class "photo-grid" ]
        (map photoView photos)


view : Model -> Html Msg
view model =
    photoGridView model.photos


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
