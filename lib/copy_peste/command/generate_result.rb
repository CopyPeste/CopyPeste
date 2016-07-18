require 'prawn'
require 'prawn/table'
require 'mongo'
require 'json'
require File.join(CopyPeste::Require::Path.copy_peste, 'DbHdlr')

module CopyPeste
  class Command
    module GenerateResult
      def run
        begin
          data = @db[:Scoring].find().sort( { timestamp: -1 } ).limit(1).to_a
          nb_file = @db[:Fichier].count()
          hash = JSON.parse(data.to_json)[0]

        rescue
          @graph_com.cmd_return(@cmd, "Collection Scoring doesn't exist", true)
          return
        end

        rows = hash['rows']
        nb_rows = rows.size
        extension = get_extension(rows)
        Prawn::Document.generate("#{hash['module']} results at #{hash['timestamp']}.pdf") do
          text "Module #{hash['module']}"
          move_up 17
          text "#{hash['timestamp']}", :align => :right
          image "./documentation/images/2017_logo_CopyPeste.png", :position => :right, :width => 140, :height => 140
          move_up 135
          text "Files analyzed : #{nb_file}"
          text "Files duplicated : #{nb_rows}"
          move_down 20
          table([
            ["Extension", "Duplication"],
            *extension
          ])
          move_down 20
          # la tableau commence ici
          table([
            ["#{hash['header'][0]}", "#{hash['header'][1]}", "#{hash['header'][2]}"],
            *rows
          ], :cell_style => { :size => 9})
          # la tableau fini ici
        end
        @graph_com.cmd_return(@cmd, "PDF has been successfully created.", false)
      end

      def get_extension(rows)
        ext = {}
        rows = rows.map {|row| row[0]}
        rows.each { |e| ext.has_key?(File.extname(e)) ? ext[File.extname(e)] += 1 : ext[File.extname(e)] = 1 }
        if ext.has_key?("")
          ext['No extension'] = ext.delete("")
        end
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
