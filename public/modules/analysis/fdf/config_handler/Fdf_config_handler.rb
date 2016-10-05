# Fdf_config_handler
#
# This class is used to get informations about the extensions the FDF should ignore
#

require_relative 'Comments_class'
require_relative 'Ignored_class'

class Fdf_config_handler

  def initialize(comments_filename = $COMMENTS, ignored_filename = $IGNORED)
    @comments_conf = Comments_class.new()
    @ignored_conf = Ignored_class.new()
  end

  def ignored_files
    @ignored_conf.ignored_files
  end

  def ignored_exts
    @ignored_conf.ignored_ext
  end

  def comments_of(ext)
    @comments_conf.get_comments(ext)
  end

  def dump_config()
    @ignored_conf.dump_config()
    @comments_conf.dump_config()
  end

end
