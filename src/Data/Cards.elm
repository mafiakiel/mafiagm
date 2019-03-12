module Data.Cards exposing (cardCategories)

import Types exposing (Card, CardCategory, Party(..), Role(..))


cardCategories : List CardCategory
cardCategories =
    [ { name = "Bürger"
      , cards =
            [ createCard Villagers
                None
                """Als normaler Bürger darf man am Tag abstimmen, welcher Spieler gehängt werden soll."""
            , createCard Villagers
                GuardianAngel
                """Der Engel kann jede Nacht einen Spieler vor einem Kill beschützen.
                   Ausnahme:
                   Der Engel beschützt nie vor dem Teufel."""
            , createCard Villagers
                Gardener
                """Der Gärtner wird von dem Dedektiv als Mafiosi gefunden, während der Inspektor/Spion ihn Gärtner erkennt."""
            , createCard Villagers
                CrackWhore
                """Als Nutte kann man jede Nacht einen Spieler vor dem Hängen am Tag beschützen. Es wird dann keiner gehängt. Stirbt man selbst, verfällt auch der Schutz."""
            , createCard Villagers
                SecretAgent
                """Der Agent kann je nach Anzahl mindestens 1 mal im Spiel nachts einen Spieler erschießen.
                   Außnahmen:
                   Der Agent kann den Teufel nicht erschießen."""
            , createCard Villagers
                Pathologist
                """Ist der Pathologe im Spiel, werden die Rollen der Toten nicht angesagt. Der Pathologe kann (je nach Anzahl der Spieler) zu einem beliebigen Zeitpunkt alle Toten überprüfen lassen. Ihre Rollen werden laut angesagt."""
            , createCard Villagers
                Cupid
                """Amor darf in der ersten Nacht zwei Spieler verlieben. Sind diese beide Bürger passiert nichts, sollten sie aber unterschiedlicher Partei angehören eröffnen die beiden eine Neue. Sie sterben gleichzeitig."""
            , createCard Villagers
                WildHilda
                """Die Wilde Hilde sucht sich am Anfang der Nacht einen Spieler aus und teilt dessen Schicksal (Tod/Vampier/Mönch/Zombie usw.). Sie selbst kann in der Nacht allerdings nicht sterben (Sie ist ja nicht 'zu Hause')."""
            , createCard Villagers
                Witch
                """Als Hexe hat man zwei Tränke zur Verfügung: Einer tötet einen belibiegen Spieler. Der andere kann zur Heilung eingesetzt werden, nachdem einem gezeigt wurde wer in der Nacht sterben wird."""
            , createCard Villagers
                Judge
                """Bei einem Unentschieden darf der Richter entscheiden, welcher Spieler (bzw. alle/keiner) gehängt werden soll."""
            , createCard Villagers
                Scapegoat
                """Sollte es bei der Tagesabstimmung ein Unentschieden geben, wird der Sündenbock gehängt."""
            , createCard Villagers
                Vegan
                """Der Veganer kann nichts besonderes, muss aber jeden Tag mindestens einmal sagen, dass er Veganer ist, sonst stirbt er."""
            , createCard Villagers
                Kidnapper
                """Der Entführer darf zu beginn des Spiels einen SPieler entführen (der das Stockholm-Syndrom hat). Die Beiden sind, falls der Entführte kein Bürger ist, eine eigene Partei. Wenn einer von beiden stirbt, begeht der andere Selbstmord."""
            , createCard Villagers
                CrimeSceneCleaner
                """Wenn der Tatortreiniger im Spiel ist wird von den Gestorbenen nur die Partei (wie vom Dedektiv gefunden) laut angesagt. Der Tatortreiniger kann ein mal aufdecken und dann werden alle Rollen angesagt."""
            , createCard Villagers Orphan "Das Weisenkind sucht sich am Anfang des Spiels einen Mitspieler als Vorbild aus. Stirbt dieser Spieler am Tag wird das Waisenkind zum Mafioso."
            , createCard Villagers Copier "Der Kopierer darf sich ein Mal im Spiel die Zusatzrolle von einem anderen Spieler kopieren und diese ab dann ausüben."
            ]
      }
    , { name = "Bürger-Checks"
      , cards =
            [ createCard Villagers
                Inspector
                """Der Inspektor kann nachts die Rolle eines Spielers erfahren.

                   Der Fund wird angesagt."""
            , createCard Villagers
                Detective
                """Der Dedektiv kann nachts die Partei eines Spielers erfahren.
                   Ausnahmen:
                   Gärtner = Mafioso
                   Politiker = Bürger
                   Graf Dracula = Bürger

                   Der Fund wird angesagt."""
            , createCard Villagers
                PrivateDetective
                """Der Privatdedektiv kann nachts die Partei eines Spielers erfahren.
                   Ausnahmen:
                   Gärtner = Mafiosi
                   Politiker = Bürger
                   Graf Dracula = Bürger"""
            , createCard Villagers
                Spy
                """Der Spion kann nachts die Rolle eines Spielers erfahren."""
            , createCard Villagers
                Statistician
                """Der Statistiker darf eine vom Spielleiter festgelegte Anzahl an Spielern aussuchen und bekommt mitgeteilt wie viele von ihnen zu den Bürgern gehören."""
            , createCard Villagers Noips """Der noipS kann nachts nach einer Rolle fragen. Der Spielleiter muss dann die Person mit dieser Rolle pantomimisch nachmachen
                                            (ohne Garantie auf Verständnis!)"""
            ]
      }
    , { name = "Mafia"
      , cards =
            [ createCard Mafia
                None
                """Als normaler Mafioso kann man nachts mit den anderen Mafiosi einen Spieler töten."""
            , createCard Mafia
                Muter
                """Der Muter darf zusätzlich zu seiner Mafiafunktion jeden Morgen jemanden stumm schalten. Derjenige stirbt, sollte er am Tag reden. Man darf jeden (auch sich selbst) beliebig hintereinander muten."""
            , createCard Mafia
                Politician
                """Der Poltiker wird vom Detektiv als Bürger gefunden, während der Inspektor/Spion ihn als Politiker erkennt."""
            , createCard Mafia
                Spy
                """Der Spion kann nachts die Rolle eines Spielers erfahren."""
            , createCard Mafia
                Judge
                """Bei einem Unentschieden darf der Richter entscheiden, welcher Spieler (bzw. alle/keiner) gehängt werden soll."""
            , createCard Mafia
                Shoemaker
                """Der Schuster kann ein mal im Spiel die Rollen von zwei SPielern vertauschen. Diese behalten aber ihre Partei bei und erhalten nur die Extrarolle des anderen Spielers."""
            , createCard Mafia
                Gardener
                """Der böse Gärtner gehört der Mafia an, wird allerdings vom Inspektor nur als Gärtner gefunden."""
            , createCard Mafia Copier "Der Kopierer darf sich ein Mal im Spiel die Zusatzrolle von einem anderen Spieler kopieren und diese ab dann ausüben."
            , createCard Mafia Noips """Der noipS kann nachts nach einer Rolle fragen. Der Spielleiter muss dann die Person mit dieser Rolle pantomimisch nachmachen
                                        (ohne Garantie auf Verständnis!)"""
            , createCard Mafia SecretAgent "Der Mafia-Agent darf wie der Bürger-Agent in der Nacht Spieler erschießen. Der Spielleiter legt fest wie viele Kugeln er zur Verfügung hat. "
            , createCard Mafia CrackWhore "Die Mafia-Nutte kann wie die normale Nutte jemanden vor dem gehängt werden am Tag beschützen."
            ]
      }
    , { name = "Kirche"
      , cards =
            [ createCard Villagers
                Pope
                """Der Papst kennt alle Mönche und kann jede Nacht einen Spieler bekehren:
                   Bürger werden Mönche.
                   Bei Mafioso/Teufel stirbt er selbst.
                   Vampire sterben."""
            , createCard Villagers
                Monk
                """Als Mönch kennt man alle Mitmönche und den Papst."""
            , createCard Villagers
                MonkInLove
                """Als verliebter Mönch kennt man alle Mitmönche. Stirbt der andere verliebte Mönch, nimmt man sich selbst das Leben."""
            ]
      }
    , { name = "Vampiere & Das Böse"
      , cards =
            [ createCard TheEvil
                Devil
                """Der Teufel wacht mit den Mafioso auf und stimmt mit diesen ab. Zusätzlich hat er einen eigenen Nachtkill. Der Schutzengel schützt nicht vor dem Teufel. Der Papst kann nicht getötet werrden."""
            , createCard TheEvil Satanist "Der Satanist spielt mit dem Teufel zusammen, hat aber keinen eigenen Kill."
            , createCard Vampires
                Dracula
                """Graf Dracula kann jede Nacht einen Spieler beißen. Weder Teufel noch Papst können zum Vampir werden.
                   Stirbt der Graf darf der älteste Vampir beißen.
                   Er wird dem Detektiv als Bürger angezeigt."""
            , createCard Vampires
                None
                """Der Vampir gehört zusammen mit Graf Dracula einer eigenen Partei an. Jede Nacht wird jemand gebissen, der evtl. auch zum Vampir wird. Wenn man vom Papst bekehrt wird stirbt man."""
            ]
      }
    , { name = "Zombies"
      , cards =
            [ createCard Zombies
                None
                """Als Zombie kann man jede Nacht einen Spieler infizieren, der anschließend in der Nacht sterben muss, um ebenfalls zum Zombie zu werden."""
            , createCard Villagers
                Infested
                """Man ist so lange ein normaler Bürger bis man in der Nacht sterben würde. Danach wird man zum Zombie und kann jede Nacht einen Spieler infizieren."""
            , createCard Villagers
                Doctor
                """Der Arzt kann einen Spieler pro Nacht heilen. Ist dieser infiziert, wird er geheilt. Bei einem normalen Bürger oder Mafioso passiert nichts. Sollte der Arzt einen Zombie auswählen, so wird er selbst infiziert und verliert das Heilen."""
            , createCard Villagers
                Nerd
                """Der Nerd wird dem Detektiv als Zombie angezeigt, obwohl er ein Bürger ist. Inspektor und Spione erkennen ihn als unschuldigen Nerd."""
            ]
      }
    ]


createCard : Party -> Role -> String -> Card
createCard party role text =
    { party = party
    , role = role
    , text = text
    }
