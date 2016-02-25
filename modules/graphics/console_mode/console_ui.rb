require 'tty-cursor'

class ConsoleUi
	def initialize
		@prompt = "$>"
	end

	def display_prompt
		print "#{@prompt} "
  end
end