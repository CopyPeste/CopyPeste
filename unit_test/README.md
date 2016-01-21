-- CUCUMBER CopyPeste --
========================

Unit test - procédure
=====================

___

1. Introduction:
-----------------

L'outil Cucumber permet à chacun d'implémenter facilement et rapidement les tests unitaires dans CopyPeste.
https://cucumber.io/

___

2. Utilisation
----------------

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
Les options permettent de définir le dossier dans l'arborescence pathTest qui sera exécutée.

___

3 - Mise en place d'un test unitaire
------------------------------------

### 	a. Arbre d’arborescence du système de test

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
- **features**, répertoire de cucumber qui sera exécuté via le Rakefile.
- **features -> scenario**, contient l'arborescence du projet CopyPeste qui est lié aux différents scénarios à exécuter.
- **features -> step_definitions**, détient les étapes qui seront exécutées, il va les chercher dans le dossier "pathTests".
- **features -> support**, configuration de Cucumber.
- **pathTest**, contient l'arborescence de CopyPeste, chaque dossier doit contenir un lien symbolique vers les tests à exécuter.

Les répertoires dans pathTest contiendront les liens symboliques vers les fichiers de tests.
```shell
$ln -s TARGET LINK_NAME
```

###	b. Prototype fichier teste

Les fichiers teste doivent être prototypés d'une certaine manière.
Tout d'abord les noms des fichiers doivent commencer par "ccb" (cucumber call back) cela permet d'avoir un nom global aux fichiers de tests, de plus il doit être de type ruby, exemple: ccbMySuperTest.rb

Le code contenu dans le fichier appelé via cucumber devra **toujours être rempli de cette manière**:
```ruby
Given /^step ccbMySuperTest loading$/ do
      #	Your arguments
end

When /^step ccbMySuperTest checking$/ do
end

Then /^step ccbMySuperTest resulting$/ do
end
```

"ccbMySuperTest" devra être modifié selon le nom du fichier teste sans l'extension.

###	c. Indiquer un problème

Pour indiquer à cucumber qu'un problème a été constaté, il suffit d'utiliser "pending", cela arrêtera le processus et cucumber indiquera l'erreur à l'utilisateur.
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
