require 'json'
require 'filemagic'

require_relative '../scan_system'
require_relative '../../algorithms/sort_file'

module CopyPeste
  class Command
    module InitBdd

      def run()
        config_path = File.join(Require::Path.root, './', 'copy_peste.yml')
        config_path = File.expand_path config_path
        config = YAML::load_file(config_path)
        if File.directory? config['ports_tree_path']
          @graph_com.display(10, "Loading directory #{config['ports_tree_path']}")
          scan = ScanSystem.new(config['ports_tree_path'])
          scan_sys scan
        else
          @graph_com.display(12, "Fail loading directory, check path in copy_peste.yml")
        end
      end

      # Add documents into the database
      #
      # @param model [Collection] collection in which data have to be inserted
      # @param json_tab [Json] document(s) to insert
      def fill_db(model, json_tab)
        @graph_com.cmd_return(@cmd, "Inserting #{json_tab.size} documents into #{model}", false)
        model.create!(json_tab)
      end


      # Create the document for the Extension collection
      #
      # @param [Hash] a hash about a file that corresponds to one type of extension
      # @param [String] the extension ("c", "cpp", etc)
      def get_extension(file, ext)
        tab_id = []
        file_tab = FileSystem.where(ext: file[:ext]).to_a
        file_tab.each { |data| tab_id << BSON::ObjectId.from_string(data.id) }
        return {
          name: ext,
          files: tab_id,
          id: file_tab[0].ext
        }
      end


      # Insert all documents scaned into the database,
      #
      # @param file_hash [Hash] files sorted by extension
      # @param scan [ScanSystem] object used to retreived files
      def sort_insert_db(file_hash, scan)
        extensions = []
        file_hash.each do |extension, file_array|
          files = []
          ext_id = BSON::ObjectId.from_time(Time.now, unique: true)
          file_array.each do |file|
            info = scan.set_info_file(ext_id, file)
            files << info if info != nil
          end
          if files.empty? == false
            fill_db(FileSystem, files)
            extensions << get_extension(files[0], extension.to_s)
          end
        end
        # save all extensions
        fill_db(Extension, extensions)
      end


      # Send files to SortFile object to be sorted by their extension
      #
      # @param tab_files [Array] files array insert
      # @return [Hash] files sorted by extension
      def send_to_sort(tab_file)
        sort = SortFile.new()
        tab_file.each do |file|
          extension = sort.get_extension(file)
          sort.sort_by_extension(file, extension)
        end
        file_hash = sort.get_hash
      end


      # Clear the database by removing all collections
      def clear_database
        FileSystem.collection.drop
        Extension.collection.drop
        AnalyseResult.collection.drop
      end

      # Start the system scan
      #
      # @param [ScanSystem] Object used to retreive files
      def scan_sys(scan)
        clear_database
        scan.init
        tab_file = scan.get_tab_file
        file_hash = send_to_sort tab_file
        sort_insert_db(file_hash, scan)
      end

      def init; end

      module_function
 
      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "Initialise database with all files into a file system"
      end

    end
  end
end
