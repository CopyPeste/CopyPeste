
# This object is use to send filname to the Levenshtein
# This object take an hash off all file needed to be compare. You can give any level of hash ex : A simple Hash. Or a Hash in a Hash etc
# for v1.1 It will return a tab containing the path of all identical file  (Voir si il y a mieux a retourner j'expliquerai plus tard)

class UseLevenshtein
  attr_accessor :file_hash

  def initialize(file_hash)
    @file_hash = file_hash
    @rsync_tab = []
  end


  def send_levenshtein(file_to_send)
    tab = []
    i = 0
    j = 1
    while i != file_to_send.size() - 1
      while j != file_to_send.size()
        file1 = file_to_send[i].split('/')
        file2 = file_to_send[j].split('/')
        if (result = Algorithms.levenshtein(file1.last(), file2.last())) == 0
          @rsync_tab << file_to_send[i]
          @rsync_tab << file_to_send[j]
        end
        puts "#{file1.last} comparer avec  #{file2.last} pour le lev distance = #{result} \n"
        j += 1
      end
      i += 1
      j = i+1
    end
    file_to_send.delete(file_to_send[0])
  end


  def level(val)
    if val.instance_of? Hash
      val.each_value {|value| level(value)}
    else
      send_levenshtein(val)
    end
  end
  

  def start
    if @file_hash.empty? == true
      return nil
    end
    @file_hash.each_value {|value| level(value)}
  end
  

  def get_result
    return @rsync_tab
  end
end
