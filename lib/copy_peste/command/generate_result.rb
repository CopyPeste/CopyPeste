require 'prawn'
require 'prawn/table'
require 'mongo'
require 'json'

module CopyPeste
  class Command
    module GenerateResult

      # generate an array on a pdf
      #
      # @param [Hash] containing data to put in the array
      # @array [Object] pdf object in which the array has to be
      def generate_array(data, pdf)
        pdf.move_down 10
        if data['title'] && data['title'] != ''
          pdf.text(data['title'], size: 9)
        end
        content = [
          data['header'],
          *data['rows']
        ]
        pdf.table(content, cell_style: {size: 9}, column_widths: [480, 60], header: true) do
          cells.borders = []
          row(0).borders = [:bottom]
          row(0).border_width = 2
          row(0).font_stye = :bold
        end
        pdf.move_down 10
      end

      # generate a text on a pdf
      #
      # @param [Hash] containing the text to print
      # @array [Object] pdf object in which the text has to be
      def generate_text(data, pdf)
        pdf.text(data['value'], size: 9)
        pdf.move_down 2
      end

      # Generate a pdf file containing formatted results, following a FDF
      # analysis execution.
      # At the end of this method, the cmd_return method (from a
      # GraphicCommunication instance) is called in order to return results
      # of this method to the loaded graphical module.
      #
      # @return [Boolean] True if the cmd_return methods success otherwise False
      def run
        begin
          ar = AnalyseResult.all.desc('_id').limit(1)
        rescue
          @graph_com.cmd_return(@cmd, "Collection AnalyseResult doesn't exist", true)
          return false
        end

        @graph_com.display(10, "Gathering data.")
        @graph_com.display(10, "Creation & printing PDF.")
        Prawn::Document.generate("#{ar.module_name']} results at #{ar.created_at}.pdf") do |pdf|
          pdf.text "Module #{ar.module_name}"
          pdf.move_up 17
          pdf.text "#{ar.created_at}", align: :right
          pdf.image "./documentation/images/2017_logo_CopyPeste.png", position: :right, width: 140, height: 140

          ar.results.each do |data|
            if data['type'] == 'array'
              generate_array(data, pdf)
            elsif data['type'] == 'text'
              generate_text(data, pdf)
            end
          end
        end
        @graph_com.cmd_return(@cmd, "PDF has been successfully created.", false)
      end

      def init
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
