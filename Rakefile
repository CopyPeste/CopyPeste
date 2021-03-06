# Sample Rakefile for Copypeste

require 'rubygems'

# Simple message to describe the use of the commands
task :default do
  abort '$rake [options]
  features		{}
  app:commands		{}
  app:core		{}
  config		{}
  examples		{}
  libs:app		{}
  libs:graphics		{}
  libs:modules		{}
  modules:graphic	{}
  module:analysis	{}
  scripts		{}
'
end

begin
  require 'cucumber'
  require 'cucumber/rake/task'

  # App Namespace
  namespace :app do
    # Graphic Task
    Cucumber:: Rake::Task.new(:commands) do |t|
        t.cucumber_opts = "--format pretty
     	  	       	  --require features features/scenarios/app/feature_commands.feature
     		       	  -r path_tests/app/commands"
    end

    # Analysis Task
    Cucumber::Rake::Task.new(:core) do |t|
       t.cucumber_opts = "--format pretty
      		       	 --require features features/scenarios/app/feature_core.feature
     		       	 -r path_tests/app/core"
    end
  end

  # Config Task
  Cucumber:: Rake::Task.new(:config) do |t|
      t.cucumber_opts = "--format pretty
   	  	       	 --require features features/scenarios/config/feature_config.feature
     		       	 -r path_tests/config"
    end


  # Example Task
  Cucumber::Rake::Task.new(:examples) do |t|
     t.cucumber_opts = "--format pretty
     		       --require features features/scenarios/examples/feature_examples.feature
     		       -r path_tests/examples/"
  end

  # Libs Namespace
  namespace :libs do
    # App Task
    Cucumber:: Rake::Task.new(:app) do |t|
        t.cucumber_opts = "--format pretty
     	  	       	  --require features features/scenarios/libs/feature_app.feature
     		       	  -r path_tests/libs/app"
    end

    # Graphics Task
    Cucumber::Rake::Task.new(:graphics) do |t|
       t.cucumber_opts = "--format pretty
      		       	 --require features features/scenarios/libs/feature_graphics.feature
     		       	 -r path_tests/libs/graphics"
    end

    # Modules Task
    Cucumber::Rake::Task.new(:modules) do |t|
       t.cucumber_opts = "--format pretty
      		       	 --require features features/scenarios/libs/feature_modules.feature
     		       	 -r path_tests/libs/modules"
    end
  end

  # Modules Namespace
  namespace :modules do
    # Graphic Task
    Cucumber:: Rake::Task.new(:graphics) do |t|
        t.cucumber_opts = "--format pretty
     	  	       	  --require features features/scenarios/modules/feature_graphics.feature
     		       	  -r path_tests/modules/graphics"
    end

    # Analysis Task
    Cucumber::Rake::Task.new(:analysis) do |t|
       t.cucumber_opts = "--format pretty
      		       	 --require features features/scenarios/modules/feature_analysis.feature
     		       	 -r path_tests/modules/analysis"
    end
  end

  # Scripts Task
  Cucumber::Rake::Task.new(:scripts) do |t|
     t.cucumber_opts = "--format pretty
    		       --require features features/scenarios/scripts/feature_scripts.feature
     		       -r path_tests/scripts"
    end

  # Running all feature
  task :features => ["app:commands", "app:core", :config, :examples, "libs:app", "libs:graphics", "libs:modules", "modules:graphics", "modules:analysis", :scripts]

rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
