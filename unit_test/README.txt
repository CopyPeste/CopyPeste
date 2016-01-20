-- CUCUMBER CopyPeste --

(Cette description concerne le dépot ProofOfConcept)

----------------
*Introduction:

L'outil Cucumber permet à chacun d'implémenter facilement et rapidement les tests unitaires de CopyTeste.

----------------
*Les commandes:

Les commandes pour lancer les tests doivent ce faire dans le dossier unit_testing à la racine du projet.
$rake algorithm
Execute les tests coté Algorithme.

$rake framework
Execute les tests coté Framework.

$rake features
Execute les tests de chaque feature.

----------------
*Ajout de tests

TREE

└── unit_test
    ├── pathTest
    ├── app
    │   ├── commands
    │   └── core
    ├── config
    ├── examples
    ├── libs
    │   ├── app
    │   ├── graphics
    │   └── modules
    ├── modules
    │   ├── analysis
    │   └── graphics
    └── scripts


Les répertoire dans unit_test contiendrons les liens symboliques vers les fichiers de test.
[ln -s TARGET LINK_NAME]

----------------
*Prototype fichier test

Les fichiers tests doivent être prototypé d'un certaine manière.
Tout d'abord le nom du fichier doit commencer par "ccb" (cucumber) cela permet d'avoir un nom global aux fichiers de tests, de plus il doit être de type ruby, exemple: ccbMySuperTest.rb

La l'argument contenu dans le fichier appelé par cucumber devra toujours être prototypé de cette manière:
Given /^step ccbMySuperTest loading$/ do
      #	Your arguments
end

Le nom 'ccbMySuperTest' sera la nom du fichier de test sans l'extension.

----------------
*Indiquer un problème

Pour indiquer à cucumber qu'un problème a était constaté, il suffit d'utiliser "pending", cela arrêtera le procésus et cucumber indiquera l'erreur à l'utilisateur.
