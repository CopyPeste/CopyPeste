
class SortProject

  def initialize
    @hash_files = {}
    @hash_key = []
  end
  
  def sort_by_project(hash_src)
    hash_src.each_value do |value|
      value.each do |file|
        id = clean_path(file)
        if @hash_files["#{id}"]
          @hash_files["#{id}"] << file
        else
          @hash_files["#{id}"] = []
          @hash_files["#{id}"] << file
        end
        
      end
    end
  end

  #{proj => [proj1, proj2], nb => [1, 2, 45, 47]}
  def sort_fdf_res_by_project(hash_src)
    tab_proj = []
    upd = false
    hash_src.each do |value|
      proj_tmp = get_proj(value[:files])
      tab_proj.each do |hsh|
        if  proj_tmp == hsh[:proj]
          hsh[:nb] << value[:diff]
          upd = true
        end

      end
      if upd == false
        tab_proj << add_hash(proj_tmp, value)
      end

      upd = false
    end
  end

  def get_hash_sorted
    @hash_files
  end

  private
  
  def clean_path(file)
    file.split("/")[1]
  end

  def add_hash(proj_tmp, hash)
    new_hash = {}
    new_hash[:proj] = []
    new_hash[:diff] = []
    new_hash[:proj] << proj_tmp
    new_hash[:diff] << hash[:diff]
    new_hash
  end
  
  def get_proj(tab_files)
    tab_tmp = []
    tab_tmp[0] = tab_files[0].split("/")[2]
    tab_tmp[1] = tab_files[1].split("/")[2]
    tab_tmp
  end
end
