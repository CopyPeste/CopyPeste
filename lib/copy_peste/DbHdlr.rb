# -*- coding: utf-8 -*-
require 'mongo'
require 'awesome_print'

module CopyPeste
  class DbHdlr

    # Creates a db instance to read/write
    #
    # @param [String] the host where the db is stored (whether an ip address or a resolved server)
    # @param [String] port to access the db service
    # @param [String] the selected database
    def initialize(host="127.0.0.1", port="27017", db="CopyPeste500")
      begin
        Mongo::Logger.logger.level = ::Logger::FATAL if CopyPeste.debug_mode == false
      rescue
        Mongo::Logger.logger.level = ::Logger::FATAL
      end

      begin
        @db_inst = Mongo::Client.new(["#{host}:#{port}"], :database => db)
      rescue
        $stderr.puts "[DbHdlr]:Error while connecting the DB. Are you sure your Mongo Server is running on #{host}:#{port} ?"
      end
    end


    # Send a record to the db
    #
    # @param [String] the collection where the new datas have to be stored
    # @param [Hash] the data to store into the db
    # @param [Bool] a toggle to know whether it's a single record or a set of records to insert
    # (false = one/ true = many)
    # @return [Int] the number of successful inserts
    def ins_data(collection, data, ins_type = false)
      begin
        if ins_type == false
          res = @db_inst[collection].insert_one data
        elsif ins_type == true
          res = @db_inst[collection].insert_many data
        end
      rescue
        $stderr.puts "[DbHdlr]:Error while inserting data to the database. Trying to record the following data in #{collection}:"
        ap data
      end
    end


    # Update a record in the db
    #
    # @param [Hash] A filter to retrieve the record to be updated
    # @param [String] the collection where the new datas have to be stored
    # @param [bson] the new data to be stored
    # @param [Bool] a toggle to know whether it's a single or many records to update at a time
    # (false = one/true = many)
    # @return [Int] the number of successful inserts
    def ud_data(filter, collection, data, updt_type = false)
      begin
        if updt_type == false
          res = @db_inst[collection].update_one(filter, data)
        elsif updt_type == true
          res = @db_inst[collection].update_many(filter, data)
        end
      rescue
        $stderr.puts 	"[DbHdlr]:Error while updating data to the database. Trying to update the document(s) matching the following
  							filter in #{collection}:"
        ap filter
        $stderr.puts "[DbHdlr]:Pushing the following data into #{collection}:"
        ap data
      end
      return res.n
    end


    def rm_data(filter, collection, del_type = false)
      begin
        if filter == nil
          res = @db_inst[collection].find().delete_many
        elsif del_type == false
          res = @db_inst[collection].delete_one filter
        elsif del_type == true
          res = @db_inst[collection].delete_many filter
        end
      rescue
        $stderr.puts 	"[DbHdlr]:Error while deleting data from the database. Trying to delete the document(s) matching the following
  							filter in #{collection}:"
        ap filter
      end
      return res.n
    end

    # Get record(s) from db
    # BEWARE : giving a nil query may cause the driver to return all the documents from
    # the selected collection, that is to say ALL THE COLLECTION CONTENTS !
    #
    # @param [String] the collection from which we'd like to get datas
    # @param [Hash] the query
    # @param [Hash] the options
    # @return [Hash] documents matching the query
    def get_data(collection, query, options = nil)
      hash = {}
      data = @db_inst[collection].find(query, options).to_a
      hash = JSON.parse(data.to_json)
      return hash
    end

    # Count the number of instances in a collection
    #
    # @param [String] the collection that has to be counted
    # @return [Integer] number of instance in the collection
    def count(collection)
      @db_inst[collection].count()
    end

    def debug(collection)
      puts "\n\n"
      @db_inst[collection].find().each { |row| puts "\n #{row.inspect}\n" }
    end
  end
end
