
# This object is use to send filname to the Levenshtein
# This object take an hash off all file needed to be compare. You can give any level of hash ex : A simple Hash. Or a Hash in a Hash etc
# for v1.1 It will return a tab containing the path of all identical file  (Voir si il y a mieux a retourner j'expliquerai plus tard)

class UseLevenshtein
  attr_accessor :fileHash

  def initialize(fileHash)
    @fileHash = fileHash
    @rsynctab = []
  end

  def sendLevenshtein(fileToSend)
    tab = []
    i = 0
    j = 1
    firstpass = true
    sizeTab = fileToSend.size()
    while i != fileToSend.size() - 1
      while j != fileToSend.size()
        file1 = fileToSend[i].split('/')
        file2 = fileToSend[j].split('/')
        if (result = Algorithms.levenshtein(file1.last(), file2.last())) == 0
          @rsynctab << fileToSend[i]
          @rsynctab << fileToSend[j]
        end
        puts "#{file1.last} comparer avec  #{file2.last} pour le lev distance = #{result} \n"
        j += 1
      end
      i += 1
      j = i+1
    end
    fileToSend.delete(fileToSend[0])
  end

  def level(val)
    if val.instance_of? Hash
      val.each_value {|value| level(value)}
    else
      sendLevenshtein(val)
    end
  end
  
  def start
    if @fileHash.empty? == true
      return nil
    end
    @fileHash.each_value {|value| level(value)}
  end
  
  def getResult
    return @rsynctab
  end
end
