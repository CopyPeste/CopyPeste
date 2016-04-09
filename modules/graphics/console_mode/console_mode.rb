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
  #  puts Dir.pwd
  #  require_relative './console_mode/console_ui'
  # require 'console_mode/console_ui'

  class ConsoleMode
    def initialize
      @alive = true
    end

    def loop
      print "cp > "
      cmd = gets
      cmd = cmd.delete!("\n")
      puts "Graphic says that your command is #{cmd}."

      cmd_hash = {:cmd => Unknown}
      if cmd == "exit"
        @alive = false
        cmd_hash[:cmd] = Exit
      elsif cmd == "help"
        cmd_hash[:cmd] = Help
      end
      cmd_hash
    end

    def running?
      @alive
    end

    def show(str)
      puts str
    end

  end
}

end
