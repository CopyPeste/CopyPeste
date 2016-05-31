#!/bin/bash

# from http://www.openbsd.org/anoncvs.html

OPT_VERSION='5.8'
OPT_FTP='ftp2.fr.openbsd.org'
OPT_LOCAL_DIRECTORY='./ports'
OPT_CVS="anoncvs@anoncvs.ca.openbsd.org:/cvs"

##
## Display information about this script
##
function displayHelp {
    echo 'getPorts.sh download ports tree of openBSD'
    echo 'possible options:'
    echo '-d: ports destination directory [default = ./ports]'
    echo '-f: ftp server [default = ftp2.fr.openbsd.org]'
    echo '-h: display this message and exit'
    echo '-v: setup OpenBSD vesion [default = 5.8]'
    exit 0
}

function initializeTree {
    ## Downoad files from openbsd server
    FILES=('ports.tar.gz' 'sys.tar.gz' 'src.tar.gz' 'xenocara.tar.gz')

    for i in ${FILES[@]}; do
	echo "Downloading ${i}..."
	wget -P $OPT_LOCAL_DIRECTORY "$OPT_FTP/pub/OpenBSD/$OPT_VERSION/${i}"
	if [ $? -ne 0 ]; then
	    echo "Error while downloading $F1. Aborting..."
	    exit 0
	fi
	echo "Done!\nExtracting ${i}..."
	tar xzf ${i}
	echo "Done!\nRemoving ${i}..."
	rm ${i}
	echo "Done!\n"
    done

    ## download ports tree
    exit 0
    cvs -qd $OPT_CVS get -P src
}

function updateTree {
    cvs -q up -Pd
}

## Test if cvs is installed

if ! hash cvs 2>/dev/null; then
    echo "the program 'cvs' is currently not installed on your system."
    exit 1
fi

## Set options
while getopts c:d:f:hv: FLAG; do
    case $FLAG in
	c) OPT_CVS=$OPT_CVS ;;
	d) OPT_LOCAL_DIRECTORY=$OPTARG ;;
	f) OPT_FTP=$OPTARG ;;
	h) displayHelp ;;
	v) OPT_VERSION=$OPTARG ;;
	\?) echo "error";;
    esac
done

## create destination directory if it doesn't exists
if [ ! -d "$OPT_LOCAL_DIRECTORY" ] ; then
    echo "Creation of destination directory $OPT_LOCAL_DIRECTORY..."
    mkdir $OPT_LOCAL_DIRECTORY
    cd $OPT_LOCAL_DIRECTORY
    echo "Done!"
    initializeTree
else
    echo "Destination directory already exists"
    cd $OPT_LOCAL_DIRECTORY
    updateTree
fi
