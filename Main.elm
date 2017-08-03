module Main exposing (main)

import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Options as Options
import Material.Scheme as Scheme
import Material.Snackbar as Snackbar


type alias Model =
    { mdl : Material.Model
    , snackbar : Snackbar.Model ()
    }


defaultModel =
    { mdl = Material.model
    , snackbar = Snackbar.model
    }


type Msg
    = AddToast
    | SnackbarMsg (Snackbar.Msg ())

    | Mdl (Material.Msg Msg)


main =
    Html.program
    { init = init
    , subscriptions = subscriptions
    , update = update
    , view = view
    }


init : (Model, Cmd Msg )
init =
    defaultModel ! [ Material.init Mdl ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdl model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddToast ->
            let
                contents =
                    Snackbar.toast () "Toast"

                ( snackbar, cmd ) =
                    Snackbar.add contents model.snackbar
            in
            { model | snackbar = snackbar } ! [ Cmd.map SnackbarMsg cmd ]

        SnackbarMsg msg_ ->
            let
                ( snackbar, cmd ) = Snackbar.update msg_ model.snackbar
            in
                { model | snackbar = snackbar } ! [ Cmd.map SnackbarMsg cmd ]

        Mdl msg_ ->
            Material.update Mdl msg_ model


view model =
    Html.div []
    [ Button.render Mdl [0] model.mdl
      [ Options.onClick AddToast
      ]
      [ text "Add toast"
      ]
    , Snackbar.view model.snackbar
      |> Html.map SnackbarMsg
    ]
    |> Scheme.top
