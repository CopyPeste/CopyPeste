require 'prawn'
require 'prawn/table'
require 'mongo'
require 'json'
require File.join(CopyPeste::Require::Path.copy_peste, 'DbHdlr')

module CopyPeste
  class Command
    module GenerateResult

      def clean(from, to, rows, current)
        (from..to).each do |i|
          next if rows[i].nil?
          rows[i] = nil if rows[i][0] == rows[current][1]
        end
      end

      def run
        begin
          data = @db[:Scoring].find().sort( { timestamp: -1 } ).limit(1).to_a
          nb_file = @db[:Fichier].count()
          hash = JSON.parse(data.to_json)[0]
          rows = hash['rows']
        rescue
          @graph_com.cmd_return(@cmd, "Collection Scoring doesn't exist", true)
          return
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

      def init_db(host="127.0.0.1", port="27017", db="CopyPeste500")
        begin
          @db = Mongo::Client.new(["#{host}:#{port}"], :database => db)

        rescue
          @graph_com.cmd_return(@cmd, "Error while connecting the DB. Are you sure your Mongo Server is running on #{host}:#{port}", true)
        end
      end

      module_function

      def helper
        "Generate a pdf that contain results of the previous analysis."
      end

    end
  end
end
