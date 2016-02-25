require 'json'

class ReceivedMessagesManager
  def initialize
    @received_msgs = Array.new
    @is_received_msg_treated = false
  end

  def jsonize_last_msg
    if @received_msgs.empty?
      @is_received_msg_treated = false
      @cur_json = nil
    else
      begin
        @cur_json = JSON.parse(@received_msgs.pop)
      rescue
        @cur_json = nil
      end
      @is_received_msg_treated = true
    end
    @cur_json
  end

  def add_new_msg(msg)
    @received_msgs << msg
  end

  def is_msg_treated?
    @is_received_msg_treated
  end

end