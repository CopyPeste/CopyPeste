require 'yaml'

class CpRequire

  def self.base_path
    File.expand_path(File.dirname(__FILE__))
  end

  def self.modules file_path
    require File.expand_path(File.dirname(__FILE__) + "/modules/" + file_path)
  end

  def self.libs file_path
    require File.expand_path(File.dirname(__FILE__) + "/libs/" + file_path)
  end

  def self.app file_path
    require File.expand_path(File.dirname(__FILE__) + "/app/" + file_path)
  end

  def self.config file_path
    require File.expand_path(File.dirname(__FILE__) + "/config/" + file_path)
  end
end

CpRequire.app 'core/core.rb'

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

  def load_config (dir = "/config/framework/", file = "default.yml")
    dir = CpRequire.base_path + dir
    YAML::load_file(File.join(dir, file)) if File.exists? (dir+file)
  end

end

CopyPeste.run
