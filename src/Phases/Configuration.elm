module Phases.Configuration exposing (configuration, rules)

import Bootstrap.Button as Button
import Bootstrap.Card as BCard
import Bootstrap.Card.Block as BCardBlock
import Bootstrap.Tab as Tab
import Bootstrap.Utilities.Spacing as Spacing
import Data.Cards exposing (cardCategories)
import Data.Strings exposing (..)
import FontAwesome exposing (icon, minus, plus)
import Html exposing (Html, text)
import List exposing (map)
import List.Extra exposing (count)
import Phases.Abstract exposing (abstractPhase)
import Types exposing (Action(..), Msg(..), Phase(..), State, Step(..))


configuration : Phase
configuration =
    Phase
        { abstractPhase
            | name = "Konfiguration"
            , steps =
                \_ ->
                    [ rules
                    , pool
                    ]
        }


rules : Step
rules =
    Step
        { name = "Regeln"
        , view = \_ -> text "Hier könnten Ihre Regeln stehen!"
        }


pool : Step
pool =
    Step
        { name = "Kartenpool"
        , view = poolView
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

        cardToBootstrapCard card =
            BCard.config []
                |> BCard.headerH3 [] [ text (roleToString card.role) ]
                |> BCard.block [] [ BCardBlock.text [] [ text card.text ] ]
                |> BCard.footer []
                    [ Button.button [ Button.secondary, Button.disabled (amountInPool card < 1) ] [ icon minus ]
                    , text <| String.fromInt <| amountInPool card
                    , Button.button [ Button.secondary, Button.onClick <| Action <| AddCardToPool card ] [ icon plus ]
                    ]

        selectCategoryAction category =
            Action (SelectCardCategory category)
    in
    Tab.config selectCategoryAction
        |> Tab.items (map categoryToTab cardCategories)
        |> Tab.view state.selectedCardCategory
