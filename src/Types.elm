module Types exposing
    ( Action(..)
    , Card
    , CardCategory
    , CardType(..)
    , CustomCardModal
    , CustomCardStep(..)
    , EditPlayerModal
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
import Bootstrap.Modal as Modal
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
    , customCardModal : CustomCardModal
    , editPlayerModal : EditPlayerModal
    , customMarkers : List Marker
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
        , view : State -> Html Action
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
    | CustomRole String


type alias Card =
    { party : Party
    , role : Role
    , text : String
    , cardType : CardType
    }


type CardType
    = BuiltInCard
    | CustomCard (List CustomCardStep)


type CustomCardStep
    = WakeUpAtFirstNight
    | WakeUpAtNight
    | WakeUpAtDawn


type alias CardCategory =
    { name : String
    , cards : List Card
    }


type alias PlayerControl =
    { label : Html Action
    , action : Player -> Action
    , options : Player -> List (Button.Option Action)
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
    | CustomMarker String Bool


type alias CustomCardModal =
    { visibility : Modal.Visibility
    , role : String
    , party : Party
    , steps : List CustomCardStep
    }


type alias EditPlayerModal =
    { playerId : Maybe Uuid
    , customMarkerLabel : String
    , customMarkerPublic : Bool
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
    | RemoveCardFromPool Card
    | AddCardToFakePool Card
    | RemoveCardFromFakePool Card
    | AddMarker Uuid Marker
    | RemoveMarker Uuid Marker
    | KillPlayer Uuid
    | EndGame
    | NominatePlayer Uuid
    | SetStealthMode Bool
    | SetNominationCountdownDuration Int
    | SetNominationCountdownRunning Bool
    | NominationCountdownFinished
    | SetCustomCardModal CustomCardModal
    | CreateCustomCard
    | EditPlayer Uuid
    | SetEditPlayerModal EditPlayerModal
    | CreateCustomMarker


type Msg
    = Undo
    | Redo
    | Action Action
