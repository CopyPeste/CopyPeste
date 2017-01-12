# -*- coding: utf-8 -*-

require 'json'
require 'parallel'
require 'mongo'
require File.join(CopyPeste::Require::Path.base, 'copy_peste/modules.rb')
require File.join(CopyPeste::Require::Path.base, 'algorithms')
require File.join(CopyPeste::Require::Path.analysis, 'fdf/config_handler/Ignored_class')

class Sps < CopyPeste::Modules::Analysis
  attr_accessor :options
  attr_accessor :show


  def initialize
    super()

    @version = "1.0 - beta"
    @authors = "CopyPeste Team"
    @description = "Search source code similarities between projects."

    @options = {}
    @options = options
    @results = {
      module: "SPS",
      options: "List of duplicated Project",
      timestamp: Time.now.getutc,
      data: []
    }

    @ignored_conf = Ignored_class.new()
  end

  # Function called to start the Sps module
  def analyse(result)
    res = {}
    if ((result_fdf = get_file_from_db) != nil)
      result_fdf.results.each do |data|
        if data._type == "ArrayResult"
          key = data.header[0].split("/")[1]
          if key != nil
            if !res.has_key?(key)
              res[key] = {}
            end

            data.rows.each do |file|
              key2 = file[0].split("/")[1]
              if !res[key].has_key?(key2) && key != key2
                res[key][key2] = [file[1]]
              elsif key != key2
                res[key][key2] << file[1]
              end

            end
          end
        end
      end

      projects = get_file_projects
      compare_projects(res, projects, result)
      true
    else
      @show.call "You must run the Fdf module before!"
      false
    end
  end

  def get_file_projects
    files = []
    # extensions = Extension.not_in(name: @ignored_conf.ignored_exts).to_a
    # extensions.each do |extension|
    #   puts extension
    #   extension["_id"] = BSON::ObjectId.from_string extension.id
    mongo_files = FileSystem.all#where(ext: extension.id).not_in(name: @ignored_conf.ignored_files)
    mongo_files.each do |file|
      files << file["path"]
    end
    # end
    return get_num_files_project files
  end

  def get_num_files_project(files)
    projects = {}
    files.each do |file|
      key = file.split("/")[1]
      if !projects.has_key?(key)
        projects[key] = 1
      else
        projects[key] += 1
      end
    end

    projects
  end

  # This functions set the pourcent average of two projects
  #
  # @param [Array] Array containing all files similarities from two project
  # in pourcent
  def compare_projects(res, projects, my_result)
    res.each do |key, value|
      if value.keys[0] != nil
        average = 0.0
        nb = 0
        value[value.keys[0]].each do |num|
          average = average + Integer(num)
        end

        if projects[key].to_i > projects[value.keys[0]].to_i
          result = average/projects[key].to_f
        else
          result = average/projects[value.keys[0]].to_f
        end
        my_result.add_text(text: "average between #{key.to_s} and #{value.keys[0].to_s} = #{result.round(2).to_s}%")
      end
    end
  end

  # This function get the documents to analyses
  def get_file_from_db
    begin
      return AnalyseResult.last
    rescue
      @graph_com.cmd_return(@cmd, "Collection AnalyseResult doesn't exist", true)
      return nil
    end
  end

  # Function used to initialize and run the fdf
  def run(result)
    result.module_name = "Sps"
    result.options = @options
    if analyse result
      @show.call "Done! Everything worked fine!"
      @show.call "You can now run generate_result to extract interesting informations."
      true
    else
      false
    end
  end
end
