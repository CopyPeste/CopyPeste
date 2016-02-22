# fileYAMLAccessControl
#
# This object is used to generate, update and remove a generic config file

require 'yaml'
require_relative 'object_YAML'

class File_YAML_access_control

  # Initialize object
  #
  # @param [name_file] no mandatory, config file path and name
  def initialize(name_file = "./file_cmp_config.yml")
    @name_file = File.expand_path(File.join(File.dirname(__FILE__), "../" + name_file))
  end

  # Delete File
  #
  # 
  def delete_file()
    File.delete(@name_file) if File.exist?(@name_file)
  end

  # Finish
  #
  # 
  def finish()
    if !@loading_file.nil?
      File.open(@name_file, 'w') do | f |
        YAML.dump(@loading_file, f)
      end
    end
  end

  # Load File
  #
  # @param [fill_in]
  def load_file(fill_in = true)
    if !File.exists? (@name_file)
      out_file = File.new(@name_file, "w")

      ignore = Ignore_obj.new()
      files = Files_obj.new(ignore)
      if (fill_in)
        fill_in_example_file(ignore)
      else
        fill_in_example_file_empty(ignore)
      end

      ignore = Ignore_obj.new()
      compare = Compare_obj.new()
      extentions = Extensions_obj.new(ignore, compare)
      if (fill_in)
        fill_in_example_ext(ignore, compare)
      else
        fill_in_example_ext_empty(ignore, compare)        
      end

      global = Global_obj.new(files, extentions);

      serialized_object = YAML::dump(global)
      # puts serialized_object
      out_file.puts YAML::load(serialized_object)
      out_file.close
    end
    @loading_file = YAML::load_file(@name_file)

    begin
      @ignore_file = @loading_file["files"]["ignore"]
      @ignore_ext = @loading_file["extensions"]["ignore"]
      @compare_ext = @loading_file["extensions"]["compare"]
    rescue Exception => msg
      STDERR.puts "Error load: " + msg.to_s
    end
  end


  # -- Get elements -- #
  def get_ignore_file()
    return @ignore_file
  end
  def get_ignore_extension()
    return @ignore_ext
  end
  def get_compare_extension()
    return @compare_ext
  end
  
  # -- Add elements -- #

  # Add ignore file
  #
  # @param [file_name]
  def add_ignore_file(file_name)
    if !@ignore_file.nil? and !@ignore_file.include? file_name
      @ignore_file.push(file_name)
      if @ignore_file[0] == nil
        @ignore_file.delete_at(0)
      end
    elsif !@ignore_file.nil? and @ignore_file.include? file_name
      STDERR.puts "Error: '#{file_name}' already contained in '#{@name_file}' 'compare extension'"
    else
      STDERR.puts "Error: '#{@name_file}' does not contain 'ignore file'"      
    end
  end

  # Add Ignore Extension
  #
  # @param [ext_name]
  def add_ignore_extension(ext_name)
    if !@ignore_ext.nil? and !@ignore_ext.include? ext_name
      @ignore_ext.push(ext_name)
      if @ignore_ext[0] == nil
        @ignore_ext.delete_at(0)
      end
    elsif !@ignore_ext.nil? and @ignore_ext.include? ext_name
      STDERR.puts "Error: '#{ext_name}' already contained in '#{@name_file}' 'ignore extension'"
    else
      STDERR.puts "Error: '#{@name_file}' does not contain 'ignore extension'"      
    end
  end

  # Add Compare Extension
  #
  # @param [ext_name]
  def add_compare_extension(ext_name)
    if !@compare_ext.nil? and !@compare_ext.include? ext_name
      @compare_ext.push(ext_name)
      if @compare_ext[0] == nil
        @compare_ext.delete_at(0)
      end
    elsif !@compare_ext.nil? and @compare_ext.include? ext_name
      STDERR.puts "Error: '#{ext_name}' already contained in '#{@name_file}' 'compare extension'"
    else
      STDERR.puts "Error: '#{@name_file}' does not contain 'compare extension'"      
    end
  end

  # -- Delete elements -- #

  # Delete Ignore File
  #
  # @param [file_name]
  def delete_ignore_file(file_name)
    if @ignore_file
      @ignore_file.delete(file_name)
    else
      STDERR.puts "Error: '#{@name_file}' does not contain 'ignore file'"      
    end
  end

  # Delete_ignore_extension
  #
  # @param [ext_name]
  def delete_ignore_extension(ext_name)
    if @ignore_ext
      @ignore_ext.delete(ext_name)
    else
      STDERR.puts "Error: '#{@name_file}' does not contain 'ignore file'"      
    end
  end

  # Delete Compare Extension
  #
  # @param [ext_name]
  def delete_compare_extension(ext_name)
    if @compare_ext
      @compare_ext.delete(ext_name)
    else
      STDERR.puts "Error: '#{@name_file}' does not contain 'ignore file'"      
    end
  end

  # -- Methodes for tests -- #

  # Display File
  #
  #
  def display_file()
    puts @loading_file
  end

  # Diplay Element File
  #
  #
  def display_elements_file()
    @loading_file.each do |elem|
      puts elem
      puts "\n"
    end
  end

  # Fill In Example File
  #
  #
  def fill_in_example_file(ignore)
    ignore.add_element("GemFile")
    ignore.add_element("Rakefile")
    ignore.add_element(".gitignore")
  end

  # Fill In Example File Empty
  #
  #
  def fill_in_example_file_empty(ignore)
    ignore.add_element("~")
  end

  # Fill In Example Extension
  #
  #
  def fill_in_example_ext(ignore, compare)
    ignore.add_element(".trash")
    ignore.add_element(".old")

    compare.add_elements([".h", ".hh"])
    compare.add_elements([".text", ".text.old", ".old"])
  end

  # Fill In Example Extension Empty
  #
  #
  def fill_in_example_ext_empty(ignore, compare)
    ignore.addElement("~")
    compare.addElements([])
  end
end
