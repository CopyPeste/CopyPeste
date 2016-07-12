module CopyPeste
  class Command
    module GenerateResult

      def run
        Prawn::Document.generate("hello.pdf") do
          text "Hello World!"
        end
      end

      def init; end
    end
  end
end
