MODULE_PATH	= ./lib/algorithms

GEMS =      bundle install

##
## Install
##########

# full install
install:	lib gem

# install and compile c library
lib:
#		pkg_add libmagic
		$(MAKE) -C $(MODULE_PATH)

# only install gems
gem:
		$(GEMS)

##
## clean
########

# remove c library
clean:
		$(MAKE) -C $(MODULE_PATH) clean

# reinstall full project
reinstall:  clean install

.PHONY:     install gem clean reinstall lib
