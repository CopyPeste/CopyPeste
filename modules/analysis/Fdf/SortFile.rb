
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
    if (extension = fileName.split('.')) == nil
      puts "#{fileName} n'as pas d'extention !!\n\n"
      return nil
    end
    return extension[1]
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
    # threads = []
    list.each do |fileName|
      # threads = Thread.new {
      if (extension = getextension(fileName)) != nil 
        tabfile = Array.new
        tabfile << fileName
        if @octe == nil || @octe.empty? == true
          fillHash(tabfile, extension)
        else
          fillHashWithOcte(tabfile, extension, i)
        end
      end
      i += 1
      # }
      # threads.each {|thr| thr.join}
      # threads.each do |thr|
      #   thr.exit
      # end
    end
    puts @fileHash
    puts "\n"
    puts "\n"
  end

  def getHash
    return @fileHash
  end
end
