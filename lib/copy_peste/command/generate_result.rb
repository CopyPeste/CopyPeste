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

        @graph_com.display(10, "Gathering data.")
        duplicated_files_nb = 0
        duplicates = []

        # iterate over all left files
        rows.size.times do |index|
          # if files have been deleted, skip
          next if rows[index].nil?
          # save filename as the current duplication list
          duplicate = [
            rows[index][0], [ [rows[index][1], rows[index][2]] ]
          ]
          duplicated_files_nb += 1
          clean(index, rows.size - 1, rows, index)
          # iterate over all other left files to search duplications
          ((index + 1)..(rows.size - 1)).each do |index2|
            # if files have been deleted, skip
            next if rows[index2].nil?
            # if a left file is similar to another, save it
            if rows[index2][0] == rows[index][0]
              duplicate[1] << [ rows[index2][1], rows[index2][2] ]
              duplicated_files_nb += 1
              clean(index2, rows.size - 1, rows, index2)
              rows[index2] = nil
            end
          end
          duplicates << duplicate
          duplicate[1].each do |e|
            e[1] = e[1].zero? ? 100 : e[1]
          end
        end

        extension = get_extension(duplicates)
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
                  *extension
                ], cell_style: {size: 9})
          move_down 60

          duplicates.each do |duplicate|
            text "<u>Duplication of file <b>#{duplicate[0]}</b>:</u>",
                 inline_format: true
            table([
                    ["File", "Similarity"],
                    *duplicate[1]
                  ], cell_style: {size: 9}, :column_widths => [493, 47] )
            move_down 20
          end

        end
        @graph_com.cmd_return(@cmd, "PDF has been successfully created.", false)
      end

      def get_extension(duplicates)
        ext = {}
        duplicates.each do |duplicate|
          if ext.has_key?(File.extname(duplicate[0]))
            ext[File.extname(duplicate[0])] += 1
          elsif
            ext[File.extname(duplicate[0])] = 1
          end
        end
        ext['No extension'] = ext.delete "" if ext.has_key? ""
        return ext
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
