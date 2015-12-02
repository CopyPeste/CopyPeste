
require 'yaml'
require './fileHandle/objectYAML'

class FileYAMLAccessControl

  def initialize(nameFile = "./file_cmp_config.yml")
    @NameFile = nameFile      
  end

  def finish()
      File.open(@NameFile, 'w') { |f|
        YAML.dump(@LoadingFile, f)
      }
  end
  
  def loadFile()
    if !File.exists? (@NameFile)
      outFile = File.new(@NameFile, "w")

      ignore = IgnoreObj.new()
      files = FilesObj.new(ignore)
      fillInExampleFile(ignore)
      
      ignore = IgnoreObj.new()
      compare = CompareObj.new()
      extentions = ExtensionsObj.new(ignore, compare)
      fillInExampleExt(ignore, compare)

      global = Globalobj.new(files, extentions);

      serialized_object = YAML::dump(global)
      # puts serialized_object
      outFile.puts YAML::load(serialized_object)
      outFile.close
    end
    @LoadingFile = YAML::load_file(@NameFile)

    begin
      @IgnoreFile = @LoadingFile["files"]["ignore"]
      @IgnoreExt = @LoadingFile["extensions"]["ignore"]
      @CompareExt = @LoadingFile["extensions"]["compare"]
    rescue Exception => msg
      puts "Error load: " + msg.to_s
    end
  end


  #/* Get elements */
  def getIgnoreFile()
    return @IgnoreFile
  end

  def getIgnoreExtension()
    return @IgnoreExt
  end
  
  def getCompareExtension()
    return @CompareExt
  end
  
  #/* Add elements */
  def addIgnoreFile(fileName)
    if @IgnoreFile
      @IgnoreFile.push(fileName)
    else
      puts "Error: '#{@NameFile}' does not contain 'ignore file'"      
    end
  end

  def addIgnoreExtension(extName)
    if @IgnoreExt
      @IgnoreExt.push(extName)
    else
      puts "Error: '#{@NameFile}' does not contain 'ignore extension'"      
    end
  end

  def addCompareExtension(extName)
    if @CompareExt
      @CompareExt.push(extName)
    else
      puts "Error: '#{@NameFile}' does not contain 'compare extension'"      
    end
  end

  #/* Delete elements */
  def deleteIgnoreFile(fileName)
    if @IgnoreFile
      @IgnoreFile.delete(fileName)
    else
      puts "Error: '#{@NameFile}' does not contain 'ignore file'"      
    end
  end

  def deleteIgnoreExtension(extName)
    if @IgnoreExt
      @IgnoreExt.delete(extName)
    else
      puts "Error: '#{@NameFile}' does not contain 'ignore file'"      
    end
  end

  def deleteCompareExtension(extName)
    if @CompareExt
      @CompareExt.delete(extName)
    else
      puts "Error: '#{@NameFile}' does not contain 'ignore file'"      
    end
  end

  #/* Methodes for test */
  def affFile()
    puts @LoadingFile
    puts "affFile"
    @LoadingFile.first.each do |elem|
      puts elem
    end
  end

  def fillInExampleFile(ignore)
    ignore.addElement("GemFile")
    ignore.addElement("Rakefile")
    ignore.addElement(".gitignore")
  end

  def fillInExampleExt(ignore, compare)

    ignore.addElement(".trash")
    ignore.addElement(".old")

    compare.addElements([".h", ".hh"])
    compare.addElements([".text", ".text.old", ".old"])
  end


end
