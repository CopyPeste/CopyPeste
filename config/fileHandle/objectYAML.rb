
class IgnoreObj
  def initialize()
    @stringObj = " ignore:\n"
  end

  def to_s
    @stringObj
  end

  def addElement(ignoreName)
    @stringObj += "  - " + ignoreName + "\n"
  end
end

class CompareObj
  def initialize()
    @stringObj = " compare:\n"
  end

  def to_s
    @stringObj
  end

  def addElements(arrayExtName)
    @stringObj += "  -\n"
    arrayExtName.each do |extName|
      @stringObj += "   - " + extName + "\n"
    end
  end
end

class FilesObj
  def initialize(obj)
    @IgnoreObj = obj
    @stringObj = "files:\n"
  end

  def to_s
    @stringObj + "#{@IgnoreObj}\n"
  end
end

class ExtensionsObj
  def initialize(ignoreObj, compareObj)
    @IgnoreObj = ignoreObj
    @CompareObj = compareObj

    @stringObj = "extensions:\n"
  end
  
  def to_s
    @stringObj + "#{@IgnoreObj}\n#{@CompareObj}\n"
  end
end


class Globalobj
  def initialize(filesObj, extensionsObj)
    @FilesObj = filesObj
    @ExtentionsObj = extensionsObj
  end
  
  def to_s
    "#{@FilesObj}\n#{@ExtentionsObj}\n"
  end
end
