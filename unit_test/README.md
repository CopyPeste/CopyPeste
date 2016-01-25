-- CUCUMBER CopyPeste --
========================

<img src="https://github.com/CopyPeste/CopyPeste/blob/master/documentation/images/british_flag.jpg" width="150">

Unit test - procedure
=====================

___

1. Introduction
---------------

Cucumber tools allow each to implement easily and quickly units tests into CopyPeste.
https://cucumber.io/

___

2. Utilisation
--------------

###	a. The commands

The commands to run tests must be in the repository unit_test in project root.
```shell
$rake [options]
```

###	b. The options

To get possible options, you need use the next command, it show each possibilities.
```shell
$rake
```
The options allow to define directory in "pathTests" tree which will be executed.

___

3 - Unit test implementation
----------------------------

### 	a. Test system tree

unit_test tree

```
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
```

####Descriptions:
- **example**, it contains example code, there are two type, functional and another with an error.
- **features**, Cucumber repository will be executed via the Rakefile.
- **features -> scenario**, it contains project tree of CopyPeste which link with various scenarios executable.
- **features -> step_definitions**, it contains executable steps, it will find in "pathTests" dossier.
- **features -> support**, Cucumber configuration.
- **pathTests**, it contains CopyPeste tree, each repository must have symbolics links toward executable tests.

The dossiers in "pathTests" contains symbolics links toward tests files.
```shell
$ln -s TARGET LINK_NAME
```

###	b. Prototype of file test

The test files must be prototype in a specific way.
First of all, the files names must begin with "ccb" (cucumber call back), it allows to have a global tests files name, more it must be ruby type, example: ccbMySuperTest.rb

The code contained in file called via Cucumber must be **always filled in of the next manner**:
```ruby
Given /^step ccbMySuperTest loading$/ do
      #	Your arguments
end

When /^step ccbMySuperTest checking$/ do
end

Then /^step ccbMySuperTest resulting$/ do
end
```

"ccbMySuperTest" will have to be modified under test file name without the extension.

###	c. Problem indication

To indicate a note problem at Cucumber, it simply to use "pending", this will stop the process and Cucumber will show the error for user.
You can add a message, like this:
```ruby
pending("ccbMySuperTest task x FAIL")
```
If you want, you can stop step without the error message, it simply to use:
```ruby
skip_this_scenario
```

4 - Updates
-----------

For update refer you at: [Flatch78](https://github.com/Flatch78) OR [kashimsax](https://github.com/kashimsax)

___
___
___

<img src="https://github.com/CopyPeste/CopyPeste/blob/master/documentation/images/french_flag.jpg" width="150">

Unit test - procédure
=====================

___

1. Introduction
---------------

L'outil Cucumber permet à chacun d'implémenter facilement et rapidement les tests unitaires dans CopyPeste.
https://cucumber.io/

___

2. Utilisation
--------------

###	a. Les commandes

Les commandes pour lancer les tests doivent se faire dans le dossier unit_test à la racine du projet.
```shell
$rake [options]
```

###	b. Les options

Pour obtenir les options possibles, il suffit d'utiliser la commande suivante qui affichera les différentes possibilités.
```shell
$rake
```
Les options permettent de définir le dossier dans l'arborescence "pathTests" qui sera exécutée.

___

3 - Mise en place d'un test unitaire
------------------------------------

### 	a. Arborescence du système de test

unit_test tree

```
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
```

####Descriptions:
- **example**, contient un exemple de code testé, il y a deux types, fonctionnel et un second contenant une erreur.
- **features**, répertoire de Cucumber qui sera exécuté via le Rakefile.
- **features -> scenario**, contient l'arborescence du projet CopyPeste qui est lié aux différents scénarios à exécuter.
- **features -> step_definitions**, détient les étapes qui seront exécutées, il va les chercher dans le dossier "pathTests".
- **features -> support**, configuration de Cucumber.
- **pathTests**, contient l'arborescence de CopyPeste, chaque dossier doit contenir un lien symbolique vers les tests à exécuter.

Les répertoires dans "pathTests" contiendront les liens symboliques vers les fichiers de tests.
```shell
$ln -s TARGET LINK_NAME
```

###	b. Prototype fichier test

Les fichiers test doivent être prototypés d'une certaine manière.
Tout d'abord, les noms des fichiers doivent commencer par "ccb" (Cucumber Call Back) cela permet d'avoir un nom global aux fichiers de tests, de plus il doit être de type ruby, exemple: ccbMySuperTest.rb

Le code contenu dans le fichier appelé via Cucumber devra **toujours être rempli de cette manière**:
```ruby
Given /^step ccbMySuperTest loading$/ do
      #	Your arguments
end

When /^step ccbMySuperTest checking$/ do
end

Then /^step ccbMySuperTest resulting$/ do
end
```

"ccbMySuperTest" devra être modifié selon le nom du fichier test sans l'extension.

###	c. Indiquer un problème

Pour indiquer à Cucumber qu'un problème a été constaté, il suffit d'utiliser "pending", cela arrêtera le processus et Cucumber indiquera l'erreur à l'utilisateur.
Vous pouvez y ajouter un message:
```ruby
pending("ccbMySuperTest task x FAIL")
```

Si vous souhaitez arrêter l'étape sans afficher de message spécifique, il suffit d'utiliser:
```ruby
skip_this_scenario
```

4 - Mise à jours
----------------

Pour toute mises à jours merci de se référer à: [Flatch78](https://github.com/Flatch78) OR [kashimsax](https://github.com/kashimsax)
