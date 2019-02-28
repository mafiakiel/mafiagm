module Types exposing (Action(..), Card, CardCategory, Flags, Model, Msg(..), Party(..), Phase(..), Player, Role(..), State, Step(..))

-- All types are defined here in a central place because Elm doesn't allow circular file dependencies.

import Bootstrap.Tab as Tab
import Html exposing (Html)
import Random
import UndoList exposing (UndoList)
import Uuid exposing (Uuid)



-- Model


type alias Model =
    UndoList State


type alias State =
    { players : List Player
    , newPlayerName : String
    , seed : Random.Seed
    , currentPhase : Phase
    , currentStep : Step
    , pool : List Card --the same card can be added to the pool multiple times
    , selectedCardCategory : Tab.State
    }


type alias Player =
    { id : Uuid
    , name : String
    }


type Phase
    = Phase
        { name : String
        , steps : State -> List Step
        , nextPhase : State -> Phase
        }


type Step
    = Step
        { name : String
        , view : State -> Html Msg
        , init : State -> State
        , stepForwardVeto : State -> Maybe String
        }


type Party
    = Villagers
    | Mafia
    | Vampires
    | TheEvil
    | Zombies


type Role
    = None
    | GuardianAngel
    | Gardener
    | Detective
    | Inspector
    | Politician
    | Drunkard
    | Cupid
    | Kidnapper
    | Judge
    | Scapegoat
    | Vegan
    | SecretAgent
    | CrackWhore
    | Pathologist
    | Witch
    | CrimeSceneCleaner
    | WildHilda
    | Statistician
    | Spy
    | PrivateDetective
    | Muter
    | Shoemaker
    | Pope
    | Monk
    | MonkInLove
    | Dracula
    | Devil
    | Nerd
    | Doctor
    | Infested
    | Orphan
    | Satanist
    | Copier
    | Noips


type alias Card =
    { party : Party
    , role : Role
    , text : String
    }


type alias CardCategory =
    { name : String
    , cards : List Card
    }


type alias Flags =
    { seed : Int }



-- Msg


type Action
    = SetNewPlayerName String
    | AddPlayer
    | RemovePlayer Uuid
    | StepForward
    | SelectCardCategory Tab.State
    | AddCardToPool Card


type Msg
    = Undo
    | Redo
    | Action Action
