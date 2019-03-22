module Phases.Configuration exposing (configuration, rules)

import Bootstrap.Badge as Badge
import Bootstrap.Button as Button
import Bootstrap.Card as BCard
import Bootstrap.Card.Block as BCardBlock
import Bootstrap.Tab as Tab
import Bootstrap.Utilities.Spacing as Spacing
import Data.Cards exposing (cardCategories)
import Data.Strings exposing (..)
import FontAwesome exposing (check, icon, minus, plus, trash)
import Html exposing (Html, div, h2, small, span, text)
import Html.Attributes exposing (class)
import List exposing (filter, length, map, member, sum)
import List.Extra exposing (count, notMember, zip)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (instruction)
import Random
import Random.List exposing (shuffle)
import Types exposing (Action(..), Msg(..), Party(..), Phase(..), PlayerControl, Role(..), State, Step(..))
import Util.Condition exposing (conditionalList)


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


rules : Step
rules =
    Step
        { abstractStep
            | name = "Regeln"
            , view = always <| text "Hier könnten Ihre Regeln stehen!"
        }


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

        categoryToTab category =
            Tab.item
                { id = category.name
                , link = Tab.link [] <| categoryTabLabel category
                , pane = Tab.pane [ Spacing.mt3 ] [ BCard.columns (map cardToBootstrapCard category.cards) ]
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
            [ text <| "Karten: " ++ String.fromInt (length state.pool)
            , small [ class "text-muted" ]
                [ text " (nicht verteilte Karten werden gefaket)" ]
            ]
        , Tab.config selectCategoryAction
            |> Tab.items (map categoryToTab cardCategories)
            |> Tab.view state.selectedCardCategory
        ]


dealCards : Step
dealCards =
    Step
        { abstractStep
            | name = "Karten verteilen"
            , view = always <| instruction "Verteile die Karten"
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
