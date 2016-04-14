require 'yaml'
require_relative './app/core/core'



#$LOAD_PATH << "./modules/graphics/"

class CopyPeste

  def self.run
    instance.run
    self
  end

  def run
    @core.start
  end

  private

  def self.new(*args, &blk)
    super(*args, &blk)
  end

  def self.instance
    @@instance ||= new
  end

  def initialize
    @conf = load_config
    @core = Core.new @conf
  end

  def load_config (dir = "./config/framework/", file = "default.yml")
    YAML::load_file(File.join(dir, file)) if File.exists? (dir+file)
  end

  def self.require_graphic_mod file_path
    require File.expand_path("./modules/graphics/" + file_path)
  end

  def self.require_analysis_mod file_path
    require File.expand_path("./modules/analysis/" + file_path)
  end

  def self.require_graphic_lib file_path
    require File.expand_path("./libs/modules/graphics/" + file_path)
  end

  def self.require_analysis_lib file_path
    require File.expand_path("./libs/modules/analysis/" + file_path)
  end

  def self.require_database_lib file_path
    require File.expand_path("./libs/database/" + file_path)
  end

  def self.require_app_lib file_path
    require File.expand_path("./libs/app/" + file_path)
  end

end

CopyPeste.run
