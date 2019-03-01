module Data.Cards exposing (cardCategories)

import Types exposing (Card, CardCategory, Party(..), Role(..))


cardCategories : List CardCategory
cardCategories =
    [ { name = "Bürger"
      , cards =
            [ createCard Villagers None "todo"
            , createCard Villagers GuardianAngel "todo"
            , createCard Villagers Gardener "todo"
            , createCard Villagers CrackWhore "todo"
            , createCard Villagers SecretAgent "todo"
            , createCard Villagers Pathologist "todo"
            , createCard Villagers Cupid "todo"
            ]
      }
    , { name = "Bürger-Checks"
      , cards = []
      }
    , { name = "Mafia"
      , cards = [ createCard Mafia None "todo" ]
      }
    , { name = "Kirche"
      , cards = []
      }
    , { name = "Vampiere & Das Böse"
      , cards = []
      }
    , { name = "Zombies"
      , cards = []
      }
    ]


createCard : Party -> Role -> String -> Card
createCard party role text =
    { party = party
    , role = role
    , text = text
    }
