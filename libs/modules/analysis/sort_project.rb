# -*- coding: utf-8 -*-

class SortProject

  def initialize
    @tab_files = []
  end

  # This function sort the documents by compared project:
  # tab_files[0] => {projects => [proj1, proj2], diffs => [25.0, 45.7...]}
  # tab_files[1] => {projects => [proj1, proj3], diffs => [78.0, 38.5...]}
  def sort_by_project(tab_src)
    tab_src.each do |hash_res|
      upd = false
      proj_tmp = get_proj(hash_res["files"])      
      @tab_files.each do |hsh|
        if  proj_tmp == hsh["projects"]
          hsh["diffs"] << hash_res["diff"]
          upd = true
        end

      end
      if upd == false && proj_tmp[0] != proj_tmp[1]
        @tab_files << add_hash(proj_tmp, hash_res)
      end

    end
  end


  # This function return the documents sorted in a tab
  #
  # @return [Arrray] Array that contain the compared projects sorted
  def get_tab_sorted
    @tab_files
  end

  private
  
  
  # This function creat a new hash with the compared project,
  # and the différence between each files
  #
  # @param [Array] array that contain the two projects names that are compared
  # @param [Hash] Hash that contain a score off a file compared in the fdf module
  def add_hash(proj_tmp, hash)
    new_hash = {}
    new_hash["projects"] = proj_tmp
    new_hash["diffs"] = []
    new_hash["diffs"] << hash["diff"]
    new_hash
  end
  
  
  # This function return the two name projects that are compared
  #
  # @param [Array] Array that contain the full path of one of the file in a project
  # @return [Array] Return an array that contain the name of the two projects compared
  def get_proj(projects)
    return projects[0].split("/")[6], projects[1].split("/")[6]
  end
end
