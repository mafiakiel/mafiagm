module Types exposing
    ( Action(..)
    , Card
    , CardCategory
    , Flags
    , Marker(..)
    , Model
    , Msg(..)
    , Party(..)
    , Phase(..)
    , Player
    , PlayerControl
    , Role(..)
    , State
    , Step(..)
    , StepMode(..)
    )

-- All types are defined here in a central place because Elm doesn't allow circular file dependencies.

import Bootstrap.Button as Button
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
    , currentStepIndex : Int
    , pool : List Card --the same card can be added to the pool multiple times
    , selectedCardCategory : Tab.State
    , fakePool : List Card
    , nextNominationPosition : Int
    , stealthMode : Bool
    , nominationCountdownDuration : Int
    , nominationCountdownRunning : Bool
    , customCards : List Card
    }


type alias Player =
    { id : Uuid
    , name : String
    , party : Party
    , role : Role
    , markers : List Marker
    , alive : Bool
    }


type Phase
    = Phase
        { name : String
        , steps : List Step
        , backgroundImage : String
        , textColor : String
        }


type Step
    = Step
        { name : String
        , view : State -> Html Msg
        , init : State -> State
        , cleanup : State -> State
        , stepForwardVeto : State -> Maybe String
        , playerControls : List PlayerControl
        , isPlayerActive : State -> Player -> Bool
        , mode : State -> StepMode
        }


type StepMode
    = Execute
    | Fake
    | Skip


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


type alias PlayerControl =
    { label : Html Msg
    , action : Player -> Action
    , options : Player -> List (Button.Option Msg)
    , condition : Player -> Bool
    }


type Marker
    = Kill
    | DevilKill
    | Protected
    | Nominated Int
    | Converted
    | InLove
    | VisitedByHilda
    | Muted
    | Alibi


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
    | RemoveCardFromPool Card
    | AddCardToFakePool Card
    | RemoveCardFromFakePool Card
    | AddMarker Uuid Marker
    | KillPlayer Uuid
    | EndGame
    | NominatePlayer Uuid
    | SetStealthMode Bool
    | SetNominationCountdownDuration Int
    | SetNominationCountdownRunning Bool
    | NominationCountdownFinished


type Msg
    = Undo
    | Redo
    | Action Action
