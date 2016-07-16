source "https://rubygems.org"
ruby '2.2.2'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Ruby String class extension. Adds methods to set text color, background color
# and, text effects on ruby console and command line output, using ANSI
# escape sequences.
# Required in
#   config/file_handler/test_file_fandler.rb
gem 'colorize'

# A ruby extension for programmatically loading dynamic libraries.
# Required in
#   libs/modules/algorithms.rb
gem 'ffi'

# Toolbox for developing CLI clients.
# Required in
#   modules/graphics/console_mode/console_ui.rb
gem 'tty', '~> 0.4.0'

# A Ruby driver for MongoDB.
# Required in
#   libs/database/DdHdlr.rb
#   scripts/init_bdd/main.rb
gem 'mongo'

# Object-Document-Mapper framework for MongoDB
# Required in
#   .
gem 'mongoid'

# This is a implementation of the JSON specification according to RFC 4627.
# Required in
#   app/copy_peste.rb
#   modules/analysis/fdf/fdf.rb
#   modules/graphics/console_mode/received_msgs_mng.rb
#   scripts/init_bdd/main.rb
gem 'json'

# Prawn is a pure Ruby PDF generation library
# Required in
#   lib/copy_peste/command/generate_result
gem 'prawn'

# Prawn-table is a library for creating table with Prawn
# Required in
#   lib/copy_peste/command/generate_result
gem 'prawn-table'

# Pretty print your Ruby objects with style.
# Required in
#   libs/database/DbHdlr.rb
gem 'awesome_print'

# Wrapper of libmagic
# Required in
#   public/init_bdd/scan_system.rb
gem 'ruby-filemagic', '~> 0.7.1'

# Tests dependancies
group :test do

  # Tool for running automated tests written in plain language
  # Required in
  #
  gem 'cucumber'

end
