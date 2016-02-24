
# SortFile is use to sort any file by their extension and optionnal with their octe.
# It take a array of file to sort, and a array of octe or nil
# It will return an Hash with a tab for value {:c=>["path1/fichier1.c", "path8/fichier1.c"]} 
# Or with octe it will return an Hash in a hash with a tab for value {:c=>{:"500"=>["path1/fichier1.c", "path8/fichier1.c"]}}

class SortFile
  attr_accessor :list, :octe, :fileHash, :rsynctab

  def initialize(list, octe)
    @list = list
    @octe = octe
    @file_hash = Hash.new
  end


  def get_extension(fileName)
    file_extension = File.extname(fileName)
    file_extension = file_extension.split('.')
    file_extension.last
  end


  def fill_hash_with_octe(tab_file, extension, i)
    if @file_hash[:"#{extension}"] == nil
      new_hash = Hash.new
      new_hash[:"#{@octe[i]}"] = tab_file
      @file_hash[:"#{extension}"] = new_hash
    else
      my_hash = @file_hash[:"#{extension}"]
      if my_hash[:"#{@octe[i]}"] == nil
        my_hash[:"#{@octe[i]}"] = tab_file
      else
        my_hash[:"#{@octe[i]}"] << tab_file[0]
      end
      @file_hash[:"#{extension}"] = my_hash
    end
  end


  def fill_hash(tab_file, extension)
    if @file_hash[:"#{extension}"] == nil
      @file_hash[:"#{extension}"] = tab_file
    else
      my_hash = @file_hash[:"#{extension}"]
      @file_hash[:"#{extension}"] << tab_file[0]
    end
  end


  def start
    i = 0
    list.each do |file_name|
      if (extension = get_extension(file_name)) == ""
        extension = "Other"
      end
      tab_file = Array.new
      tab_file << file_name
      if @octe == nil || @octe.empty? == true
        fill_hash(tab_file, extension)
      else
        fill_hash_with_octe(tab_file, extension, i)
      end
      i += 1
    end
  end

  def get_hash
    return @file_hash
  end
end
