module Data.Strings exposing (partyToString, roleToString)

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
            "Paspt"

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
        
        EvilGardener ->
            "böser Gärtner"


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
