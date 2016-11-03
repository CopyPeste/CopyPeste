require 'json'
require 'filemagic'

require_relative '../scan_system'
require_relative '../../algorithms/sort_file'

module CopyPeste
  class Command
    module InitBdd

      def run()
        scan = ScanSystem.new("../../BimBimGo")
        scan_sys scan
      end

      # Add document into the database
      #
      # @param [String] name of the collection to use
      # @param [JSON] a json Array (tab[0] => json_document, tab[1] => json_document).
      #               Or a simple json file
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
      # @parma [Hash] a hash containing files sorted by extension
      # @parma [Object] a ScanSystem object
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
      # @parma [Array] File array to insert
      # @Return [Hash] return a hash that contain files sort by extension
      def send_to_sort(tab_file)
        sort = SortFile.new()
        tab_file.each do |file|
          extension = sort.get_extension(file)
          sort.sort_by_extension(file, extension)
        end
        file_hash = sort.get_hash
      end


      # Clear the database, remove all files and result
      def clear_database
        FileSystem.collection.drop
        Extension.collection.drop
        AnalyseResult.collection.drop
      end

      # Start the scan of the system
      #
      # @param [Object] Object ScanSystem
      def scan_sys(scan)
        clear_database
        scan.init
        tab_file = scan.get_tab_file
        file_hash = send_to_sort tab_file
        sort_insert_db(file_hash, scan)
      end

      def init
      end

      def helper
      end

    end
  end
end
