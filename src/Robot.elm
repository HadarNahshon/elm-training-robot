module Robot exposing (main)

import Browser
import Html
import Html.Attributes exposing (style)
import Keyboard
import Maybe
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
    = Tick Time.Posix
    | SetTimeZone Time.Zone Time.Posix


type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick


init : flags -> ( Model, Cmd Msg )
init _ =
    ( { time = Time.millisToPosix 0
      , zone = Time.utc
      }
    , Task.perform identity <| Task.map2 SetTimeZone Time.here Time.now
    )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Tick timePosix ->
            ( { model | time = timePosix }
            , Cmd.none
            )

        SetTimeZone zone posix ->
            ( { model | time = posix, zone = zone }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    let
        millis : Int
        millis =
            modBy 1000 (millisLeft model)

        secondsLeft : Int
        secondsLeft =
            millisLeft model // 1000

        seconds : Int
        seconds =
            modBy 60 secondsLeft

        minutesLeft : Int
        minutesLeft =
            secondsLeft // 60

        minutes : Int
        minutes =
            modBy 60 minutesLeft

        hoursLeft : Int
        hoursLeft =
            minutesLeft // 60

        hours : Int
        hours =
            modBy 24 hoursLeft

        daysLeft : Int
        daysLeft =
            hoursLeft // 24

        days : Int
        days =
            modBy 7 daysLeft

        weeksLeft : Int
        weeksLeft =
            daysLeft // 7
    in
    Html.div []
        [ Html.div [ style "color" (backgroundColor model seconds) ]
            [ Html.text "Time until kickoff ~!"
            ]
        , Html.div []
            [ Html.text <|
                String.fromInt weeksLeft
                    ++ " weeks "
                    ++ String.fromInt days
                    ++ " days "
                    ++ String.fromInt hours
                    ++ " hours "
                    ++ String.fromInt minutes
                    ++ " minutes "
                    ++ String.fromInt seconds
                    ++ " seconds"
            ]
        ]
