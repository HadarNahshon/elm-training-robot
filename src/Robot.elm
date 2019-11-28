module Robot exposing (main)

import Browser
import Browser.Events exposing (onKeyDown)
import Html
import Html.Attributes exposing (style)
import Json.Decode
import Maybe
import String


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
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    onKeyDown <| Json.Decode.map KeyPressed <| Json.Decode.field "key" Json.Decode.string


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { x = 10
      , y = 10
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyPressed button ->
            let
                move action =
                    ( { model | x = action model.x 1 }, Cmd.none )
            in
            case button of
                --- each key name is the character outputted, except for arrow keys: ArrowDown, ArrowUp... etc
                "a" ->
                    move (-)

                "d" ->
                    move (+)

                "w" ->
                    move (-)

                "s" ->
                    move (+)

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
            , style "top" <| String.fromInt model.y ++ "%"
            , style "left" <| String.fromInt model.x ++ "%"
            ]
            []
        ]
