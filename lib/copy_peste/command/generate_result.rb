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
          hash = JSON.parse(data.to_json)[0]
        rescue
          @graph_com.cmd_return(@cmd, "Collection Scoring doesn't exist", true)
          raise
        end
        
        rows = hash['rows']
        
        duplicates = []
        # iterate over all left files
        (0..(rows.size - 1)).each do |index|
          # if files have been deleted, skip
          next if rows[index].nil?
          # save filename as the current duplication list
          duplicate = [
            rows[index][0].split('/').last, [
              [rows[index][1], rows[index][2]]
            ]
          ]
          # iterate over all other left files to search duplications
          ((index + 1)..(rows.size - 1)).each do |index2|
            # if files have been deleted, skip
            next if rows[index2].nil?
            # if a left file is similar to another, save it
            if rows[index2][0] == rows[index][0]
              duplicate[1] << [
                rows[index2][1],
                rows[index2][2]
              ]
              rows[index2] = nil
            end
          end
          duplicates << duplicate
        end

        Prawn::Document.generate("#{hash['module']} results at #{hash['timestamp']}.pdf") do
          text "#{hash['module']}"
          text "#{hash['timestamp']}", :align => :right
          duplicates.each do |duplicate|
            text "<u>Duplication of file <b>#{duplicate[0]}</b>:</u>",
                 inline_format: true
            table([
                    ["file", "similarity"],
                    *duplicate[1]
                  ], cell_style: {size: 9})
          end
        end
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
      
    end
  end
end
