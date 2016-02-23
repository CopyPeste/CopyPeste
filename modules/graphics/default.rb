
consoleGraphicalModule  do
	description {
		"This is a console mode graphical module for CopyPeste."
	}

	author { "Team Framework" }

	usage { 'Just run it!' }

	init { ConsoleMode.new() }

	impl {
		require 'tty-cursor'
		require '../modules/graphics/console_mode/console_ui.rb'
		require '../modules/graphics/console_mode/received_msgs_mng.rb'
		require '../modules/graphics/console_mode/core_requests_handler.rb'
		
		class ConsoleMode
                def initialize
                	@ui = ConsoleUi.new
                	@rcv_msgs_mng = ReceivedMessagesManager.new
                	@core_requests_handler = CoreRequestsHandler.new
        			@ui.display_prompt
                end

                def _loop(selector)
                	json_request = @rcv_msgs_mng.jsonize_last_msg
                	@core_requests_handler.execute json_request unless json_request.nil?
                	@ui.display_prompt if @rcv_msgs_mng.is_msg_treated?
                end

                def _callback_for_read(source_stream)
					message = source_stream.dequeue.chomp()
					puts "|_ Received '#{message}' from server."
					@rcv_msgs_mng.add_new_msg message
                end
      
                def _callback_for_write(source_stream)
                	puts "Just wrote a message"
                end
		end
	}	

end
