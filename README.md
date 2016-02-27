Welcome to the CopyPeste project.

Born from the recognition of a real lack of visibility about possible redundancies, duplications or vulnerabilities contained in openBSD's ports tree, CopyPeste is a research project which aims to analyze all these sources to generate data about the ports tree.
In order to find interesting data, several analysis modules are in development. Each of them  realizes simple tasks like finding all duplicates files in the ports tree (eg: FDF module). A Framework is also in construction to easily manage, configure and use the analysis modules.

Development currently in progress.

### Initialiazation:

```sh
$> cd scripts/
$> bundle install
$> cd init_bdd
$> ruby main.rb /usr/ports
```
