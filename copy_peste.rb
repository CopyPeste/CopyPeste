require 'yaml'
require_relative './app/core/core'


class LoadEnvironment
  @@path

  def self.require_analysis

  end
end

$LOAD_PATH << "./modules/graphics/"
#$LOAD_PATH << "./modules/analysis/"

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
    return YAML::load_file(File.join(dir, file)) if File.exists? (dir+file)
    nil
  end

end

CopyPeste.run
