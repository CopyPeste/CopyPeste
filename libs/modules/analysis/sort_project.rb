
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

  def get_hash_sorted
    @hash_files
  end

  private
  
  def clean_path(file)
    file.split("/")[1]
  end
end
