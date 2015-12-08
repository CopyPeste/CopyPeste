
require 'yaml'
require './fileHandler/objectYAML'

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
    if @IgnoreFile and !@IgnoreFile.include? fileName
      @IgnoreFile.push(fileName)
    elsif @IgnoreFile.include? fileName
      puts "Error: '#{fileName}' already contained into '#{@NameFile}' 'compare extension'"
    else
      puts "Error: '#{@NameFile}' does not contain 'ignore file'"      
    end
  end

  def addIgnoreExtension(extName)
    if @IgnoreExt and !@IgnoreExt.include? extName
      @IgnoreExt.push(extName)
    elsif @IgnoreExt.include? extName
      puts "Error: '#{extName}' already contained into '#{@NameFile}' 'ignore extension'"
    else
      puts "Error: '#{@NameFile}' does not contain 'ignore extension'"      
    end
  end

  def addCompareExtension(extName)
    if @CompareExt and !@CompareExt.include? extName
      @CompareExt.push(extName)
    elsif @CompareExt.include? extName
      puts "Error: '#{extName}' already contained into '#{@NameFile}' 'compare extension'"
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

  #/* Methodes for tests */
  def displayFile()
    puts @LoadingFile
  end

  def displayElementsFile()
    @LoadingFile.each do |elem|
      puts elem
      puts "\n"
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
