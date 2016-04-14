consoleGraphicalModule  do
  description {
    "This is a console mode graphical module for CopyPeste."
  }

  author { "Team Framework" }

  usage { 'Just run it!' }

  init {
    ConsoleMode.new()
  }


  impl {
    CopyPeste.require_graphic_mod 'console_mode/parser'

    class ConsoleMode
      def initialize
        @alive = true
        @prompt = "cp > "
      end

      def loop
        print @prompt
        cmd = gets
        cmd_hash = Parser.parse cmd
        @alive = false if cmd_hash[:cmd] == "exit"
        cmd_hash
      end

      def running?
        @alive
      end

      def show(hash)
        if hash[:code] == 1
          puts "[debug] Command: #{hash[:data][:cmd]} - Ouput: #{hash[:data][:output]}".green
          if hash[:data][:cmd] == "use_analysis_module"
            @prompt = "cp (#{hash[:data][:output].red}) > "
          end
        elsif hash[:code] == 2
          puts "[debug] Msg to display: #{hash[:data][:msg]}".green
        elsif hash[:code] == 3
          puts "[debug] Error: #{hash[:data][:output]}".green
        end
      end

    end
  }

end
