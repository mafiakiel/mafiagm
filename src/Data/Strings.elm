module Data.Strings exposing (cardTitle, partyToString, roleToString)

import Types exposing (..)


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
            "verliebter Mönch"

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


partyToString : Party -> String
partyToString party =
    case party of
        Villagers ->
            "Bürger"

        Mafia ->
            "Mafia"

        Vampires ->
            "Vampiere"

        TheEvil ->
            "Das Böse"

        Zombies ->
            "Zombies"


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
