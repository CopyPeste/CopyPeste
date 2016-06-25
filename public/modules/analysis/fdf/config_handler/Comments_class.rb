$COMMENTS = "comments_by_ext.yml"

require_relative 'Config_class'

class Comments_class < Config_class

  def initialize(comments_filename = $COMMENTS)
    super(comments_filename);
  end

  def get_comments(ext)
    @conf["comments"][ext]
  end

end
