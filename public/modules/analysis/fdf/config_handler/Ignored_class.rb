require_relative 'Config_class'

$IGNORED = "ignored.yml"

class Ignored_class < Config_class

  def initialize(ignored_filename = $IGNORED)
    super(ignored_filename)
  end

  def ignored_files
    @conf["ignored"]["files"]
  end

  def ignored_exts
    @conf["ignored"]["extensions"]
  end

end
