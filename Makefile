MODULE_PATH	= ./lib/algorithms

GEMS =      bundle install

INIT =      cd './public/init_bdd/' && ruby main.rb ~/test


##
## Install
##########

# full install
install:	lib gem init

# only compile c library
lib:
		$(MAKE) -C $(MODULE_PATH)

# only install gems
gem:
		$(GEMS)

# only initialise the database
init:
		$(INIT)

##
## clean
########

# remove c library
clean:
		$(MAKE) -C $(MODULE_PATH) clean

# reinstall full project
reinstall:  clean install

.PHONY:     install gem clean reinstall lib
