Welcome to the CopyPeste project.

Born from the recognition of a real lack of visibility about possible redundancies, duplications or vulnerabilities contained in openBSD's ports tree, CopyPeste is a research project which aims to analyze all these sources to generate data about the ports tree.
In order to find interesting data, several analysis modules are in development. Each of them  realizes simple tasks like finding all duplicate files in the ports tree (eg: FDF module). A Framework is also in construction to easily manage, configure and use the analysis modules.

### Prerequisites

* Download OpenBSD's ports tree
* have MongoDB and libmagic-dev (`sudo pkg_add libmagic-dev`)

### Installation:

```sh
$> git clone https://github.com/CopyPeste/CopyPeste.git
$> cd CopyPeste  
$> make install
```

### Initialisation

To avoid too many resources consumption, CopyPeste uses an internal MongoDB database instead of browsing multiple times the file system. It has to be initialised at the first launch thanks to the command `init_bdd`.

### Example of use

This example shows how to initialise the database, use a module and its options (here the fdf that search for file duplication) and generate results under the form of a PDF.

```sh
$> ./bin/copy_peste.rb
CP > init_bdd
... Done.
CP > use fdf
CP (fdf) > set_opts p 80
CP (fdf) > run
... Done.
CP (fdf) > exit_mod
CP > generate_result
... Done.
CP > exit
```

For more information, please check our [wiki](https://github.com/CopyPeste/CopyPeste/wiki) 
