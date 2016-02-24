
# SortFile is use to sort any file by their extension and optionnal with their octe.
# It take a array of file to sort, and a array of octe or nil
# It will return an Hash with a tab for value {:c=>["path1/fichier1.c", "path8/fichier1.c"]} 
# Or with octe it will return an Hash in a hash with a tab for value {:c=>{:"500"=>["path1/fichier1.c", "path8/fichier1.c"]}}

class SortFile
  attr_accessor :list, :octe, :fileHash, :rsynctab

  def initialize(list, octe)
    @list = list
    @octe = octe
    @fileHash = Hash.new
  end


  def getextension(fileName)
    file_extension = File.extname(fileName)
    file_extension = file_extension.split('.')
    return file_extension.last
  end


  def fillHashWithOcte(tabfile, extension, i)
    if @fileHash[:"#{extension}"] == nil
      newHash = Hash.new
      newHash[:"#{@octe[i]}"] = tabfile
      @fileHash[:"#{extension}"] = newHash
    else
      myHash = @fileHash[:"#{extension}"]
      if myHash[:"#{@octe[i]}"] == nil
        myHash[:"#{@octe[i]}"] = tabfile
      else
        myHash[:"#{@octe[i]}"] << tabfile[0]
      end
      @fileHash[:"#{extension}"] = myHash
    end
  end


  def fillHash(tabfile, extension)
    if @fileHash[:"#{extension}"] == nil
      @fileHash[:"#{extension}"] = tabfile
    else
      myHash = @fileHash[:"#{extension}"]
      @fileHash[:"#{extension}"] << tabfile[0]
    end
  end


  def start
    i = 0
    list.each do |fileName|
      if (extension = getextension(fileName)) == ""
        extension = "Other"
      end
      tabfile = Array.new
      tabfile << fileName
      if @octe == nil || @octe.empty? == true
        fillHash(tabfile, extension)
      else
        fillHashWithOcte(tabfile, extension, i)
      end
      i += 1
    end
  end

  def getHash
    return @fileHash
  end
end
