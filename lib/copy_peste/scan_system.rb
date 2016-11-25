# class use to scan all files contained in a directory

class ScanSystem
  attr_accessor :start_point


  # Create a ScanSystem instance
  #
  # @param start_point [String] path of the start point to scan
  def initialize(start_point)
    @start_point = start_point
    @dir = Dir.new(@start_point)
    @tab_file = []
    @fm = FileMagic.new(FileMagic::MAGIC_MIME)
  end


  # Start the scan of the system
  #
  # @param path [String] the path where to start to scan
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


  # Check if a file is binary.
  #
  # @param filenamen [String] full file path
  # @return [Bool] return whether the file is a binary
  def binary?(filename)
    !(@fm.file(filename)=~ /^text\//)
  end


  # put files scaned in the list to be sort later
  #
  # @param file [String] full file path
  def put_in_list(file)
    #return if binary?(file) == true
    @tab_file << file
  end


  # @return [Array] tab_file
  def get_tab_file
    @tab_file
  end


  # initialize the start point for the scan
  def init
    puts "Start browsing files..."
    start @start_point
    puts "Stop browsing files"
    @fm.close
  end

  # Create a hash that containing information about a file
  #
  # @param ext_id [ObjectId] the ObjectId of the extension (same ObjectId for all same extension)
  # @param files [String] the complete file path
  # @return [Hash] file information or nil if file doesn't exists.
  def set_info_file(ext_id, file)
    return nil if File.file?(file) == false || File.readable?(file) == false
    return {
      name: (File.split(file)).last,
      path: (File.split(file)).first,
      size: File.size(file),
      ext: ext_id
    }
  end
end
