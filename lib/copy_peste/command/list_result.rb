module CopyPeste
  class Command
    module ListResult

      # Method used to display result list of module.
      #
      # @param result [Collection] collection data of result list
      # @param name [String] Name of module, could be nil
      def display_results(results, name)


        results = (name && !name.empty?) ? results.where(:module_name => name) : results
        unless results.empty?
          @graph_com.display(10, "Module\t| Date\n------\t| ----")
          results.each do |data|
            @graph_com.display(10, "#{data.module_name}\t| #{data.created_at}")
          end
          
        else
          @graph_com.display(12, "Option 'n' error, name #{name} not found") 
        end
      end
      
      # Allows a user to diplay result list generated by analysis module
      def run
        options = {
          "n" => {
            helper: "Name of module",
            value: ''
          },
        }

        name = ''
        # Option set name
        if @opts.length == 2
          if options.key?(@opts[0])
            name = @opts[1].to_s
            
          else
            @graph_com.display(12, "Option [#{@opts[0]}] of list_result does not exists.")
            return
          end
        end

        results = AnalyseResult.only(:module_name, :created_at)
        unless results.empty?
          display_results(results, name)

        else # ... "No generated result matching"
          @graph_com.display(12, "No result generated, use a module before.")
        end
      end

      def init; end

      module_function

      # Method used by the help command in order to explain the aim of this module.
      #
      # @return [String] a string containing the command purpose.
      def helper
        "Display the list of results generated by analysis modules."
      end
    end
  end
end
