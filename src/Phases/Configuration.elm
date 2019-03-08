module Phases.Configuration exposing (configuration, rules)

import Bootstrap.Button as Button
import Bootstrap.Card as BCard
import Bootstrap.Card.Block as BCardBlock
import Bootstrap.Tab as Tab
import Bootstrap.Utilities.Spacing as Spacing
import Data.Cards exposing (cardCategories)
import Data.Strings exposing (..)
import FontAwesome exposing (icon, minus, plus, trash)
import Html exposing (Html, div, h2, small, span, text)
import Html.Attributes exposing (class)
import List exposing (drop, length, map, member)
import List.Extra exposing (count, notMember, zip)
import Phases.Abstract exposing (abstractPhase, abstractStep)
import Phases.Common exposing (instruction)
import Random
import Random.List exposing (shuffle)
import Types exposing (Action(..), Msg(..), Phase(..), PlayerControl, State, Step(..))


configuration : Phase
configuration =
    Phase
        { abstractPhase
            | name = "Konfiguration"
            , steps =
                [ rules
                , pool
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
                    if length state.players > length state.pool then
                        Just "Es sind weniger Karten im Pool, als es Spieler gibt."

                    else
                        Nothing
            , playerControls = [ deletePlayerControl ]
        }


poolView : State -> Html Msg
poolView state =
    let
        categoryToTab category =
            Tab.item
                { id = category.name
                , link = Tab.link [] [ text category.name ]
                , pane = Tab.pane [ Spacing.mt3 ] [ BCard.columns (map cardToBootstrapCard category.cards) ]
                }

        amountInPool card =
            count ((==) card) state.pool

        cardOptions card =
            if member card state.pool then
                [ BCard.outlineSuccess ]

            else
                []

        cardToBootstrapCard card =
            BCard.config ([ BCard.attrs [ class "pool-card" ] ] ++ cardOptions card)
                |> BCard.headerH5 [] [ text (roleToString card.role) ]
                |> BCard.block [] [ BCardBlock.text [] [ text card.text ] ]
                |> BCard.footer []
                    [ Button.button
                        [ Button.secondary
                        , Button.onClick <| Action <| RemoveCardFromPool card
                        , Button.disabled <| notMember card state.pool
                        ]
                        [ icon minus ]
                    , span [ class "pool-card-amount" ] [ text <| String.fromInt <| amountInPool card ]
                    , Button.button [ Button.secondary, Button.onClick <| Action <| AddCardToPool card ] [ icon plus ]
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
        , undealtPool = drop (length cardPlayerPairs) shuffledPool
    }
