require 'yaml'

$CONFIG_FILES_PATH = "../../config_files/"

class Config_class

  @conf = {}

  def initialize(config_file_name)
    @file_path = File.expand_path(File.join(File.dirname(__FILE__), $CONFIG_FILES_PATH + config_file_name))
    if File.exist?(@file_path)
      load_config_from_file()
    else
      print "No cmp config file. Did you remove the default file?"
    end
  end

  def self.file_path
    @file_path
  end

  def self.conf
    @conf
  end

  def load_config_from_file()
    @conf = YAML.load_file(@file_path)
  end

  def dump_config()
    puts @conf.to_yaml
  end

end
