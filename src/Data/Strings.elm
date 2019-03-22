module Data.Strings exposing
    ( cardTitle
    , customCardStepDictionary
    , customCardText
    , partyDictionary
    , partyToString
    , roleToString
    )

import List exposing (length, map)
import String exposing (join)
import Types exposing (..)
import Util.Dictionary as Dictionary exposing (Dictionary)


roleToString : Role -> String
roleToString role =
    case role of
        None ->
            "(keine)"

        GuardianAngel ->
            "Schutzengel"

        Gardener ->
            "Gärtner"

        Detective ->
            "Detektiv"

        Inspector ->
            "Inspektor"

        Politician ->
            "Politiker"

        Drunkard ->
            "Trunkenbold"

        Cupid ->
            "Amor"

        Kidnapper ->
            "Entführer"

        Judge ->
            "Richter"

        Scapegoat ->
            "Sündenbock"

        Vegan ->
            "Veganer"

        SecretAgent ->
            "Agent"

        CrackWhore ->
            "Crack-Nutte"

        Pathologist ->
            "Pathologe"

        Witch ->
            "Hexe"

        CrimeSceneCleaner ->
            "Tatortreiniger"

        WildHilda ->
            "Wilde Hilde"

        Statistician ->
            "Statistiker"

        Spy ->
            "Spion"

        PrivateDetective ->
            "Privatdetektiv"

        Muter ->
            "Muter"

        Shoemaker ->
            "Schuster"

        Pope ->
            "Papst"

        Monk ->
            "Mönch"

        MonkInLove ->
            "Verliebter Mönch"

        Dracula ->
            "Graf Dracula"

        Devil ->
            "Teufel"

        Nerd ->
            "Nerd"

        Doctor ->
            "Arzt"

        Infested ->
            "Infizierter"

        Orphan ->
            "Waisenkind"

        Satanist ->
            "Satanist"

        Copier ->
            "Kopierer"

        Noips ->
            "noipS"

        CustomRole name ->
            name


partyToString : Party -> String
partyToString =
    Dictionary.getString partyDictionary


partyDictionary : Dictionary Party
partyDictionary =
    [ ( Villagers, "Bürger" )
    , ( Mafia, "Mafia" )
    , ( Vampires, "Vampire" )
    , ( TheEvil, "Das Böse" )
    , ( Zombies, "Zombies" )
    ]


cardTitle : Card -> String
cardTitle card =
    if card.role == Gardener && card.party == Mafia then
        "Böser Gärtner"

    else if card.role == None then
        case card.party of
            Villagers ->
                "Normaler Bürger"

            Mafia ->
                "Normaler Mafioso"

            Vampires ->
                "Normaler Vampir"

            Zombies ->
                "Normaler Zombie"

            TheEvil ->
                "<does not exist>"

    else
        roleToString card.role


customCardStepDictionary : Dictionary CustomCardStep
customCardStepDictionary =
    [ ( WakeUpAtFirstNight, "in der ersten Nacht" )
    , ( WakeUpAtNight, "in der Nacht" )
    , ( WakeUpAtDawn, "am Morgen" )
    ]


customCardText : CustomCardModal -> String
customCardText card =
    "Partei: "
        ++ partyToString card.party
        ++ (if length card.steps == 0 then
                "\n\nWacht nicht auf."

            else
                "\n\nWacht auf: " ++ join ", " (map (Dictionary.getString customCardStepDictionary) card.steps)
           )
