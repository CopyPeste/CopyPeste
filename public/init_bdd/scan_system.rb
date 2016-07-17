# class use to scan all the file containe in a directory

class ScanSystem
  attr_accessor :start_point


  # Create a ScanSystem instance
  #
  # @param [String] path of the start point to scan
  def initialize(start_point)
    @start_point = start_point
    @dir = Dir.new(@start_point)
    @tab_file = []
    @fm = FileMagic.new(FileMagic::MAGIC_MIME)
  end


  # Start the scan of the system
  #
  # @parma [String] the path where you start to scan
  def start(path)
    begin
      Dir.foreach(path) do |file|
        if file != "." && file != ".."
          if path[path.length - 1] != '/'
            tmp = path + "/" + file
          else
            tmp = path + file
          end
          File.directory?(tmp) ? start(tmp) : put_in_list(tmp)
        end
      end
    rescue => e
      puts e.message
    end
  end


  # Check if a file is a binary.
  #
  # @param [String] full path file
  # @Return [Bool] return whether the file is a binary
  def binary?(filename)
    !(@fm.file(filename)=~ /^text\//)
  end


  # put files scaned in the list to be sort later
  #
  # @parma [String] file full path (/home/test/toto.c)
  def put_in_list(file)
    #return if binary?(file) == true
    @tab_file << file
  end


  # return tab_file
  def get_tab_file
    @tab_file
  end


  # initialize the start point for the scan
  def init
    puts "Start browsing files..."
    path = @start_point
    start path
    puts "Stop browsing files"
    @fm.close
  end

  # Create a hash that will contains informations about one file
  #
  # @param [ObjectId] the ObjectId of the extension (same ObjectId for all same extension)
  # @param [String] the complete path of the file
  # @Return [nil] return nil if the file don't exist or if the file is not readable
  def set_info_file(ext_id, files)

    if File.file?(files) == true && File.readable?(files)
      hash_info = {}
      hash_info[:name] = (File.split(files)).last
      hash_info[:path] = (File.split(files)).first
      hash_info[:size] = File.size(files)
      hash_info[:ext] = ext_id
      hash_info.to_json
    else
      return nil
    end
  end
end
