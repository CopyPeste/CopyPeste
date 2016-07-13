module CopyPeste
  class Command
    module GenerateResult
    require 'prawn'
    require 'mongo'
    require 'awesome_print'
    require File.join(CopyPeste::Require::Path.copy_peste, 'DbHdlr')
# test si y'a deja des analyse sinon erreur
      def run
        query = {}
        opts = {}
        query["timestamps"] = nil
        begin
          data = @db.Scoring.find("timestamps").limit(1).sort({timestamps:1})
          hash = JSON.parse(data.to_json)
          puts hash
          result_time = @client.get_data("Scoring", query, opts)
          puts result_time
        rescue
          $stderr.puts "Collection Scoring doesn't exist"
        end
        Prawn::Document.generate("hello.pdf") do
          text "Hello World!"
        end
      end

      def init
        @client = DbHdlr.new()
        init_db
      end

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
