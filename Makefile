GEMS =      bundle install

INIT =      cd 'scripts/init_bdd/' && \
			ruby main.rb


install:
			$(MAKE) -C ./libs/modules/analysis

gem:
			$(GEMS)

init:
			$(INIT)

clean:
			$(MAKE) -C ./libs/modules/analysis clean

reinstall:  clean install

.PHONY:     install gem clean reinstall
