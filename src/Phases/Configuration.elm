module Phases.Configuration exposing (configuration)

import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Card as BCard
import Bootstrap.Card.Block as BCardBlock
import Bootstrap.Form as Form
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Input as Input
import Bootstrap.Modal as Modal
import Bootstrap.Tab as Tab
import Bootstrap.Utilities.Spacing as Spacing
import Data.Cards exposing (cardCategories, customCategoryName)
import Data.Strings exposing (..)
import FontAwesome exposing (check, icon, minus, plus, trash)
import Html exposing (Html, br, div, h2, p, span, text)
import Html.Attributes exposing (class)
import List exposing (filter, length, map, member, sum)
import List.Extra exposing (count, notMember, remove, zip)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (simpleInstruction)
import Random
import Random.List exposing (shuffle)
import Types exposing (Action(..), CustomCardModal, CustomCardStep(..), Msg(..), Party(..), Phase(..), PlayerControl, Role(..), State, Step(..))
import Util.Condition exposing (conditionalList)
import Util.Dictionary as Dictionary


configuration : Phase
configuration =
    Phase
        { abstractPhase
            | name = "Konfiguration"
            , steps =
                [ pool
                , dealCards
                ]
            , backgroundImage = "%PUBLIC_URL%/img/configuration.jpg"
        }


deletePlayerControl : PlayerControl
deletePlayerControl =
    { label = icon trash
    , action = \player -> RemovePlayer player.id
    , options = always [ Button.danger ]
    , condition = always True
    }



{- rules : Step
   rules =
       Step
           { abstractStep
               | name = "Regeln"
               , view = always <| text "Hier könnten Ihre Regeln stehen!"
           }
-}


pool : Step
pool =
    Step
        { abstractStep
            | name = "Kartenpool"
            , view = poolView
            , stepForwardVeto =
                \state ->
                    if length state.players /= length state.pool then
                        Just "Es müssen genau so viele Karten im Pool sein, wie es Spieler gibt."

                    else
                        Nothing
            , playerControls = [ deletePlayerControl ]
        }


poolView : State -> Html Msg
poolView state =
    let
        cardsInPool category =
            map (\c -> filter ((==) c) state.pool) category.cards
                |> map length
                |> sum

        cardsInFakePool category =
            filter (\c -> member c state.fakePool) category.cards
                |> length

        categoryTabLabel category =
            conditionalList
                [ ( True, text category.name )
                , ( cardsInPool category > 0, Badge.pillSuccess [ Spacing.ml1 ] [ text <| String.fromInt <| cardsInPool category ] )
                , ( cardsInFakePool category > 0, Badge.pillDark [ Spacing.ml1 ] [ text <| String.fromInt <| cardsInFakePool category ] )
                ]

        customCardModal =
            state.customCardModal

        openCustomCardModal =
            Action <| SetCustomCardModal { customCardModal | visibility = Modal.shown }

        additionalTabContent category =
            if category.name == customCategoryName then
                [ BCard.config []
                    |> BCard.block []
                        [ BCardBlock.text []
                            [ text "Hier kannst du eigene Karten erstellen."
                            , br [] []
                            , br [] []
                            , Button.button [ Button.primary, Button.onClick openCustomCardModal ] [ icon plus, text " Karte hinzufügen" ]
                            ]
                        ]
                ]

            else
                []

        categoryToTab category =
            Tab.item
                { id = category.name
                , link = Tab.link [] <| categoryTabLabel category
                , pane = Tab.pane [ Spacing.mt3 ] [ BCard.columns (map cardToBootstrapCard category.cards ++ additionalTabContent category) ]
                }

        amountInPool card =
            count ((==) card) state.pool

        cardOptions card =
            if member card state.pool then
                [ BCard.outlineSuccess ]

            else if member card state.fakePool then
                [ BCard.outlineDark ]

            else
                []

        fakeButton card =
            if member card state.fakePool then
                Button.button [ Button.dark, Button.onClick <| Action <| RemoveCardFromFakePool card ]
                    [ icon check, text " Fake" ]

            else
                Button.button [ Button.outlineDark, Button.onClick <| Action <| AddCardToFakePool card ] [ text "Fake" ]

        cardToBootstrapCard card =
            BCard.config ([ BCard.attrs [ class "pool-card" ] ] ++ cardOptions card)
                |> BCard.headerH5 [] [ text (cardTitle card) ]
                |> BCard.block [] [ BCardBlock.text [] [ text card.text ] ]
                |> BCard.footer []
                    [ Button.button
                        [ Button.dark
                        , Button.onClick <| Action <| RemoveCardFromPool card
                        , Button.disabled <| notMember card state.pool
                        ]
                        [ icon minus ]
                    , span [ class "pool-card-amount" ] [ text <| String.fromInt <| amountInPool card ]
                    , Button.button
                        [ Button.dark
                        , Button.onClick <| Action <| AddCardToPool card
                        , Button.disabled <| member card state.fakePool
                        ]
                        [ icon plus ]
                    , fakeButton card
                    ]

        selectCategoryAction category =
            Action (SelectCardCategory category)
    in
    div []
        [ h2 []
            [ text <| "Karten: " ++ String.fromInt (length state.pool) ]
        , Tab.config selectCategoryAction
            |> Tab.items (map categoryToTab (cardCategories state))
            |> Tab.view state.selectedCardCategory
        , customCardModalView state.customCardModal
        ]


customCardModalView : CustomCardModal -> Html Msg
customCardModalView customCardModal =
    let
        closeCustomCardModal =
            Action <| SetCustomCardModal { customCardModal | visibility = Modal.hidden }

        setStepChecked step checked =
            if checked then
                Action <| SetCustomCardModal <| { customCardModal | steps = step :: customCardModal.steps }

            else
                Action <| SetCustomCardModal <| { customCardModal | steps = remove step customCardModal.steps }

        stepCheckboxes =
            map
                (\( step, label ) ->
                    Checkbox.checkbox
                        [ Checkbox.checked <| member step customCardModal.steps
                        , Checkbox.onCheck <| setStepChecked step
                        ]
                        label
                )
                customCardStepDictionary

        setRole role =
            Action <| SetCustomCardModal <| { customCardModal | role = role }

        setParty party =
            Action <| SetCustomCardModal <| { customCardModal | party = party }
    in
    Modal.config closeCustomCardModal
        |> Modal.small
        |> Modal.hideOnBackdropClick True
        |> Modal.h3 [] [ text "Karte erstellen" ]
        |> Modal.body []
            [ Form.form []
                [ Form.group [] [ Form.label [] [ text "Rolle" ], Input.text [ Input.value customCardModal.role, Input.onInput setRole ] ]
                , Form.group [] [ Form.label [] [ text "Partei" ], Dictionary.toBootstrapSelect partyDictionary setParty Villagers ]
                , Form.group [] ([ Form.label [] [ text "Aufwachen?" ] ] ++ stepCheckboxes)
                ]
            ]
        |> Modal.footer []
            [ Button.button [ Button.onClick closeCustomCardModal ] [ text "Abbrechen" ]
            , Button.button
                [ Button.primary
                , Button.disabled <| customCardModal.role == ""
                , Button.onClick <| Action CreateCustomCard
                ]
                [ text "OK" ]
            ]
        |> Modal.view customCardModal.visibility


dealCards : Step
dealCards =
    Step
        { abstractStep
            | name = "Karten verteilen"
            , view = always <| simpleInstruction "Verteile die Karten"
            , init = dealCardsInit
        }


dealCardsInit : State -> State
dealCardsInit state =
    let
        resetPlayers =
            map (\p -> { p | alive = True, markers = [] }) state.players

        ( shuffledPool, newSeed ) =
            Random.step (shuffle state.pool) state.seed

        cardPlayerPairs =
            zip shuffledPool resetPlayers

        dealCardToPlayer ( card, player ) =
            { player | role = card.role, party = card.party }
    in
    { state
        | seed = newSeed
        , players = map dealCardToPlayer cardPlayerPairs
    }
