require 'prawn'
require 'prawn/table'
require 'mongo'
require 'json'
require File.join(CopyPeste::Require::Path.copy_peste, 'DbHdlr')

module CopyPeste
  class Command
    module GenerateResult

      # Generate a pdf file containing formatted results, following a FDF
      # analysis execution.
      # At the end of this method, the cmd_return method (from a
      # GraphicCommunication instance) is called in order to return results
      # of this method to the loaded graphical module.
      # @return [Boolean] True if the cmd_return methods success otherwise False.
      def run
        begin
          data = @db[:Scoring].find().sort( { timestamp: -1 } ).limit(1).to_a
          nb_file = @db[:Fichier].count()
          hash = JSON.parse(data.to_json)[0]
          rows = hash['rows']
        rescue
          @graph_com.cmd_return(@cmd, "Collection Scoring doesn't exist", true)
          nil
        end

        duplicated_files_nb = 0
        extensions = {}
        rows.each do |reff, files|
          duplicated_files_nb += files.length
          extension = File.extname(reff)
          if extensions.key?(extension)
            extensions[extension] += files.length
          else
            extensions[extension] = files.length
          end
        end
        sorted_extensions = []
        extensions.each {|key, value| sorted_extensions << [key, value] }
        sorted_extensions.sort! {|a, b| b[1] <=> a[1]}

        @graph_com.display(10, "Gathering data.")
        @graph_com.display(10, "Creation & printing PDF.")
        Prawn::Document.generate("#{hash['module']} results at #{hash['timestamp']}.pdf") do
          text "Module #{hash['module']}"
          move_up 17
          text "#{hash['timestamp']}", align: :right
          image "./documentation/images/2017_logo_CopyPeste.png", position: :right, width: 140, height: 140
          move_up 135
          text "Analyzed files: #{nb_file}"
          text "Duplicated files: #{duplicated_files_nb}"
          move_down 20
          table([
                  ["Extension", "Duplication"],
                  *sorted_extensions
                ], cell_style: {size: 9})
          move_down 60

          rows.each do |reff, files|
            display_files = []
            files.each { |file| display_files << [file["path"], file["similarity"]] }
            text "<u>Duplication of file <b>#{reff}</b>:</u>",
                 inline_format: true
            table([
                    ["File", "Similarity"],
                    *display_files
                  ], cell_style: {size: 9}, :column_widths => [493, 47] )
            move_down 20
          end

        end
        @graph_com.cmd_return(@cmd, "PDF has been successfully created.", false)
      end

      def init
        @client = DbHdlr.new()
        init_db
      end

      private

      # Instantiate the MongoDb connection in order to get and format generated
      # data from a given analysis.
      # @return [Boolean] True if the cmd_return methods success otherwise False.
      def init_db(host="127.0.0.1", port="27017", db="CopyPeste500")
        begin
          @db = Mongo::Client.new(["#{host}:#{port}"], :database => db)

        rescue
          @graph_com.cmd_return(@cmd, "Error while connecting the DB. Are you sure your Mongo Server is running on #{host}:#{port}", true)
        end
      end

      module_function

      # Give a string used by the help command in order to explain the aim of
      # this command.
      # @return [String] a string containing the explaination of the command.
      def helper
        "Generate a pdf that contain results of the previous analysis."
      end

    end
  end
end
