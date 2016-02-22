
class Ignore_obj
  def initialize()
    @string_obj = " ignore:\n"
  end

  def to_s
    @string_obj
  end

  def add_element(ignore_name)
    @string_obj += "  - " + ignore_name + "\n"
  end
end

class Compare_obj
  def initialize()
    @string_obj = " compare:\n"
  end

  def to_s
    @string_obj
  end

  def add_elements(array_ext_name)
    @string_obj += "  -\n"
    array_ext_name.each do |ext_name|
      @string_obj += "   - " + ext_name + "\n"
    end
  end
end

class Files_obj
  def initialize(obj)
    @ignore_obj = obj
    @string_obj = "files:\n"
  end

  def to_s
    @string_obj + "#{@ignore_obj}\n"
  end
end

class Extensions_obj
  def initialize(ignore_obj, compare_obj)
    @ignore_obj = ignore_obj
    @compare_obj = compare_obj

    @string_obj = "extensions:\n"
  end
  
  def to_s
    @string_obj + "#{@ignore_obj}\n#{@compare_obj}\n"
  end
end


class Global_obj
  def initialize(files_obj, extensions_obj)
    @files_obj = files_obj
    @extentions_obj = extensions_obj
  end
  
  def to_s
    "#{@files_obj}\n#{@extentions_obj}\n"
  end
end
