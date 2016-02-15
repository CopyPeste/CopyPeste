require 'socket'
require '../../libs/app/threads_communication/selector'

consoleGraphicalModule  do
	description {
		"This is a console mode graphical module for CopyPeste."
	}

	author { "Team Framework" }

	usage { 'Just run it!' }

	run { ConsoleMode.new().run }

	impl {
		class ConsoleMode
			def initialize
				puts "Console mode is instantiate."
				client = TCPSocket.new("0.0.0.0", 4242)
				@selector = Selector.new(nil)
				@prompt = false

				# attaching the io to the selector
				@client_stream = @selector.register_io client

				# configuring the callback used after the stream write something
				@client_stream.callback_for_read do |client_stream|
					message = @client_stream.dequeue
					puts "Received '%s' from server." % message
				end

				@client_stream.callback_for_write do |client_stream|
					puts "Just wrote a message"
					@prompt = false
				end

				@client_stream.callback_for_close do |client_stream|
					puts "Connection closed by the server"
					exit
				end

				# starting the monitoring of the stream
				@client_stream.listen :read


				console_stream = @selector.register_io STDIN
				console_stream.callback_for_read(@client_stream) do |console_s, client_s|
					message = console_s.dequeue
					client_s.queue message
				end
				console_stream.listen :read
				
				end

			def run
				puts 'Run method called.'
				print '$> '
				@selector.loop() do |selector, *_|
					puts "loop start"
  					print '$> ' if @prompt == true
  					@prompt = true if @prompt == false
  					puts "loop end"
				end
				@client_stream = @client_stream.close!

				sleep 2
				puts "Bye world"
			end
		end
	}	

end