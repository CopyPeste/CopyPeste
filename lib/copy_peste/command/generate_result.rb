require 'prawn'
require 'prawn/table'
require 'mongo'
require 'json'

module CopyPeste
  class Command
    module GenerateResult

      # Generate a pdf containing formatted results of the last analysid module
      # At the end of this method, the cmd_return method (from a
      # GraphicCommunication instance) is called in order to return results
      # of this method to the loaded graphical module.
      #
      # @return [Boolean] True if the cmd_return methods success otherwise False
      def run
        begin
          ar = AnalyseResult.last
          ar.module_name # check if ar is nil
        rescue
          @graph_com.cmd_return(@cmd, "Collection AnalyseResult doesn't exist", true)
          return false
        end

        @graph_com.display(10, "Gathering data.")
        @graph_com.display(10, "Creation & printing PDF.")
        Prawn::Document.generate("#{ar.module_name} results at #{ar.created_at}.pdf") do |pdf|
          pdf.text "Module #{ar.module_name}"
          pdf.move_up 17
          pdf.text "#{ar.created_at}", align: :right
          pdf.image "./documentation/images/2017_logo_CopyPeste.png", position: :right, width: 140, height: 140

          ar.results.each do |data|
            if data._type == "ArrayResult"
              generate_array(data, pdf)
            elsif data._type == "TextResult"
              generate_text(data, pdf)
            end
          end
        end
        @graph_com.cmd_return(@cmd, "PDF has been successfully created.", false)
      end

      def init; end

      private

      # Generate an array on a pdf
      #
      # @param data [Hash] data to put in the array
      # @param pdf [Prawn::document] pdf object in which the array has to be created
      def generate_array(data, pdf)
        pdf.move_down 10
        if data.title && data.title != ''
          pdf.text(data.title, size: 9)
        end
        content = [
          data.header,
          *data.rows
        ]
        pdf.table(content, cell_style: {size: 9}, column_widths: [480, 60], header: true) do
          cells.borders = []
          row(0).borders = [:bottom]
          row(0).border_width = 2
          row(0).font_stye = :bold
        end
        pdf.move_down 10
      end

      # Generate a text on a pdf
      #
      # @param data [Hash] text to print
      # @param pdf [Prawn::document] pdf object in which the text has to be created
      def generate_text(data, pdf)
        pdf.text(data.text, size: 9)
        pdf.move_down 2
      end

      module_function

      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "Generate a pdf that contain results of the previous analysis."
      end

    end
  end
end
