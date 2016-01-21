-- CUCUMBER CopyPeste --
========================

Unit test - procédure
=====================

___

1. Introduction:
-----------------

L'outil Cucumber permet à chacun d'implémenter facilement et rapidement les tests unitaires de CopyPeste.
https://cucumber.io/

___

2. Utilisations
----------------

###	..2. Les commandes

Les commandes pour lancer les tests doivent se faire dans le dossier unit_test à la racine du projet.
```shell
$rake [options]
```

###	..2. Les options

Pour obtenir les options possible, il suffit d'utiliser la commande suivante qui affichera les différentes possibilitées.
"""
$rake
"""
Les options permettent de définir le dossier dans l'arborescence pathTest qui sera executé.

___

3 - Mise en place d'un test unitaire
------------------------------------

### 	..3. Arbre d’arborescence du système de test

unit_test tree


unit_test/
├── example
│   └── unit_test
├── features
│   ├── scenarios
│   │   ├── app
│   │   ├── config
│   │   ├── examples
│   │   ├── libs
│   │   ├── modules
│   │   └── scripts
│   ├── step_definitions
│   │   ├── app
│   │   ├── config
│   │   ├── examples
│   │   ├── libs
│   │   ├── modules
│   │   └── scripts
│   └── support
└── pathTests
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

**Description:**
- example, contient un exemple de code testé, il y a deux types, fonctionnel et un second contenant une erreur.
- features, répertoire de cucumber qui sera executé via le Rakefile.
- features -> scenario, contient l'arborescence du projet CopyPeste lié au différent scénario à éxecuter.
- features -> step_definitions, détient les étapes qui seront éxécutées, il va les chercher dans le dossier "pathTests".
- features -> support, configuration de Cucumber.
- pathTest, contient l'arborescence de CopyPeste, chaque dossier doit contenir un lien symbolique vers les tests à executer. 

Les répertoire dans pathTest contiendrons les liens symboliques vers les fichiers de test.
$ln -s TARGET LINK_NAME

###	..3. Prototype fichier test

Les fichiers tests doivent être prototypé d'un certaine manière.
Tout d'abord les noms des fichiers doivent commencer par "ccb" (cucumber call back) cela permet d'avoir un nom global aux fichiers de tests, de plus il doit être de type ruby, exemple: ccbMySuperTest.rb

Le code contenu dans le fichier appelé via cucumber devra **toujours être prototypé de cette manière**:
```ruby
Given /^step ccbMySuperTest loading$/ do
      #	Your arguments
end

When /^step ccbMySuperTest checking$/ do
end

Then /^step ccbMySuperTest resulting$/ do
end
```

Le nom 'ccbMySuperTest' sera le nom du fichier de test sans l'extension.

###	..3. Indiquer un problème

Pour indiquer à cucumber qu'un problème a été constaté, il suffit d'utiliser "pending", cela arrêtera le procésus et cucumber indiquera l'erreur à l'utilisateur.
Vous pouvez y ajouter un message:
```ruby
pending("ccbMySuperTest task x FAIL")
```

Si vous souhaitez arrêter le programme sans afficher de message spécifique, il suffit d'utiliser "skip_this_scenario".
