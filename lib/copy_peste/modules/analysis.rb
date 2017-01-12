require_relative '../modules.rb'

module CopyPeste
  module Modules

    class Analysis < CopyPeste::Modules::Base

      attr_accessor :options
      attr_accessor :show

      def initialize
        super()
        @type = "analysis"
        @options = {}
        @show = nil
      end

      # Function used to initialize and run the analysis module
      # Results aren't saved because it's done into the framework
      #
      # @param result [AnalyseResult] resulting object of the analysis that will be saved later on, on which to aggregate data
      # @see CopyPeste::Command::RunAnalysisModule#run
      def run(result)
        false
      end

    end

  end
end
