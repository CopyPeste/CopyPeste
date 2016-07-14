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
          puts hash

        rescue
          $stderr.puts "Collection Scoring doesn't exist"
          raise
        end

        rows = hash['rows']
        Prawn::Document.generate("#{hash['module']} results at #{hash['timestamp']}.pdf") do
          text "#{hash['module']}"
          text "#{hash['timestamp']}", :align => :right
          table([
            ["#{hash['header'][0]}", "#{hash['header'][1]}", "#{hash['header'][2]}"],
            *rows
          ])
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
          $stderr.puts "[DbHdlr]:Error while connecting the DB. Are you sure your Mongo Server is running on #{host}:#{port} ?"
        end
      end

    end
  end
end
