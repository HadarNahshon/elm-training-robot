module Robot exposing (main)

import Browser
import Browser.Events exposing (onKeyDown)
import Html
import Html.Attributes exposing (style)
import Json.Decode
import Keyboard
import Maybe
import String
import Task


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = KeyPressed String


type alias Model =
    { x : Int
    , y : Int
    , btt : String
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    onKeyDown <| Json.Decode.map KeyPressed <| Json.Decode.field "key" Json.Decode.string


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { x = 10, y = 10, btt = "a" }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyPressed button ->
            case button of
                --- each key name is the character outputted, except for arrow keys: ArrowDown, ArrowUp... etc
                "a" ->
                    ( { model | x = model.x - 1, btt = button }, Cmd.none )

                "d" ->
                    ( { model | x = model.x + 1, btt = button }, Cmd.none )

                "w" ->
                    ( { model | y = model.y - 1, btt = button }, Cmd.none )

                "s" ->
                    ( { model | y = model.y + 1, btt = button }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.div
            [ style "background-color" "blue"
            , style "width" "50px"
            , style "height" "50px"
            , style "position" "absolute"
            , style "top" <| (++) (String.fromInt model.y) "%"
            , style "left" <| (++) (String.fromInt model.x) "%"
            ]
            [ Html.text model.btt
            ]
        ]
