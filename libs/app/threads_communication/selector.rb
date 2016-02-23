class Selector
  MONITORABLE_EVENT_TYPES = [:read, :write]

  def initialize(timeout = 1)
    @streams = []
    @timeout = timeout
    @must_stop = false
    MONITORABLE_EVENT_TYPES.each do |event_type|
      self.instance_variable_set "@looking_to_#{event_type}", []
    end
  end

  # Create a new stream from the IO and add it to the selector
  #
  # @param [IO] io
  # @return [Selector::Stream] the created one, or nil if already registered
  def register_io(io)
    stream = Stream.new(io, self)
    register_stream stream
  end

  # Tell if a stream is registered by the instance
  #
  # @param [Selector::Stream] stream
  # @return [Boolean]
  def registered?(stream)
    @streams.include? stream
  end

  # Register the stream if its IO is not already registered
  #
  # @param [Selector::Stream] stream
  # @return [Selector::Stream] param or nil if already registered
  def register_stream(stream)
    unless find_stream_from_io(stream.io)
      @streams << stream
      stream
    end
  end

  # Unregister a stream from the instance.
  # It will first stop the monitoring of events.
  #
  # @param [Selector::Stream] stream
  def unregister_stream!(stream)
    if registered? stream
      MONITORABLE_EVENT_TYPES.each do |event_type|
        update_stream_monitoring_status(stream, event_type, false)
      end

      @streams.delete stream
    end

    nil
  end

  # Update the way to listen at events for a stream
  #
  # @param [Selector::Stream] stream
  # @param [Array] *args
  # @example listen(stream, :write)
  #  will monitor 'write' events
  # @example listen(stream, :read => false, :write)
  #  will monitor 'write' events but un-monitor 'read' events
  def listen(stream, *args)
    unless @streams.include? stream
      raise "Stream not registered for this selector."
    end

    args.each do |event|
      if event.kind_of? Hash
        event.each do |event_type, status|
          puts "~~~~ #{event_type} => #{status}"
          update_stream_monitoring_status(stream, event_type, status)
        end

      else
        update_stream_monitoring_status(stream, event, true)
      end
    end

    nil
  end

  # Loop (until it must stop) over the 'select' method, calling the given block
  # and triggering the callbacks associated to the registered streams in case
  # of monitored events happen.
  #
  # @param [Array] *args passed as parameters to the block
  # @param [Proc] block (optional) first parameter sent is the stream
  def loop(*args, &block)
    return if block_given? && block.arity.zero?

    @must_stop = false
    until @must_stop
      puts "I'm the client's selector and I'm entering a new round" if args.empty? # DEBUG
      puts "I'm the client's selector and I'm listening for '#{@looking_to_write}' streams on write" if args.empty? # DEBUG
      all_events = select(@looking_to_read, @looking_to_write, [], @timeout)
      puts "I'm the client's selector and I just passed the select()" if args.empty? # DEBUG
      # if events are registered
      unless all_events.nil?

        # for every types of event monitored
        read_events, write_events = all_events

        # iterates over the ios that received events and call the
        # associated callback

        read_events.each do |io|
          puts "I'm the client's selector and I'm going to read" if args.empty? # DEBUG
          stream = find_stream_from_io(io)
          action = ( stream.can_accept? || !io.eof?) ? :read : :close
          stream.trigger_callback_for(action)
          puts "I'm the client's selector and I just read" if args.empty? # DEBUG
        end

        write_events.each do |io|
          puts "I'm the client's selector and I'm going to write" if args.empty? # DEBUG
          stream = find_stream_from_io(io)
          stream.trigger_callback_for(:write)
          puts "I'm the client's selector and I just wrote" if args.empty? # DEBUG
        end
      end

      puts "I'm the client's selector and I'm entering the yield" if args.empty? # DEBUG
      yield(self, *args) if block_given?
      puts "I'm the client's selector and I'm exiting the yield" if args.empty? # DEBUG
    end

    # unregister every streams but the server-stream
    nil
  end

  # Change the loop condition to make it stop on its next iteration
  #
  def must_stop!
    @must_stop = true
  end

  class Stream
    CALLBACKABLE_EVENTS = (Selector::MONITORABLE_EVENT_TYPES << :close).uniq

    attr_reader :io

    # Initialize a new Selector::Stream object
    #
    # @param [IO] io
    # @param [Selector] selector handling the stream
    def initialize(io, selector)
      @io, @selector = io, selector
      CALLBACKABLE_EVENTS.each do |event_type|
        self.instance_variable_set "@on_#{event_type}", []
        self.instance_variable_set "@buffer_of_#{event_type}s", []
      end
    end

    # Make sure nothing will try to read on this instance
    #
    def is_accepting!
      @is_accepting = true
      nil
    end

    # Tell if the stream can still perform read actions or if it is
    # performing accept() calls.
    #
    # @return [Boolean]
    def can_accept?
      @is_accepting
    end

    # Define the behavior to adopt on an event
    #
    # @param [Symbole] action in :read, :write, :close
    # @param [Array] args passed to the block
    # @param [Proc] block, arity >= 1, first parameter send is the instance
    # @return [NilClass]
    def callback_for(action, *args, &block)
      instance_variable_set "@on_#{action}", [block, args]
      nil
    end

    # Defining helpers #callback_for_read, #callback_for_write and
    # #callback_for_close using #callback_for method
    #
    # @see #callback_for
    CALLBACKABLE_EVENTS.each do |action|
      define_method "callback_for_#{action}" do |*args, &block|
        self.callback_for(action.to_sym, *args, &block)
      end
    end

    # Tell the selector to listen for these types of event
    #
    # @note 'write' events are unlistened once all queued messages are sent
    # @param [Array] *event_types
    def listen(*event_types)
      event_types.each { |e_t| update_selector_listening(e_t, true) }
      nil
    end

    # Tell the selector to stop listening at these types of event
    #
    # @param [Array] *event_types
    def stop_listening(*event_types)
      event_types.each { |e_t| update_selector_listening(e_t, false) }
      nil
    end

    # Trigger the callbacks when an event happened
    #
    # @param [Symbole] event_type
    def trigger_callback_for(event_type)
      ensure_valid_event_type! event_type
      send("handle_#{event_type}")
      block, args = on_(event_type)
      block.call(self, *args) unless block.nil?
      nil
    end

    # Queue message that will be send when the io will be open for writes
    #
    # @param [String] message
    def queue(message)
      unless @buffer_of_writes.nil?
        @buffer_of_writes << message
        @selector.listen(self, :write)
      end

      nil
    end

    # Retrieve the oldest element available from the read side of the io
    #
    # @return [String] nil if empty
    def dequeue
      @buffer_of_reads.shift unless @buffer_of_reads.nil?
    end

    # Unregister the instance from its selector and close the IO.
    #
    # @example
    #  stream = stream.close!
    #  => nil
    def close!
      handle_close
    end

    private

    # Update the monitoring status of events for the instance in the
    # selector handling it
    #
    # @param [Symbole] event_type
    # @status [Boolean]
    def update_selector_listening(event_type, status)
      @selector.listen(self, event_type => status)
    end

    # Ensure validity of the type of event passed.
    # It throws an exception otherwise.
    #
    # @param [Symbole] event_type
    def ensure_valid_event_type!(event_type)
      unless CALLBACKABLE_EVENTS.include? event_type
        raise "Unvalid event type '#{event_type}'."
      end
    end

    # Return the instance variable dedicated for this type of events
    #
    # @param [Symbole] event_type
    # @return [Array]
    def on_(event_type)
      self.instance_variable_get("@on_#{event_type}")
    end

    # Get line from the io and insert it back in the buffer of read messages
    #
    def handle_read
      unless @is_accepting || @buffer_of_reads.nil?
        message = io.readline
        @buffer_of_reads << message
      end

      nil
    end

    # Puts queued message in the io and unlisten
    #
    # @note will stop listening 'write' events if queue is empty
    def handle_write
      unless @buffer_of_writes.nil?
        message = @buffer_of_writes.shift
        io.puts message
        puts "=========== wrote #{message}" # DEBUG
        stop_listening(:write) if @buffer_of_writes.empty?
        puts "=========== #{@buffer_of_writes.size} #{@buffer_of_writes.empty?}" # DEBUG
      end

      nil
    end

    # Unregister the stream from the selector and close the IO.
    #
    def handle_close
      @selector.unregister_stream!(self)
      @io.close
      nil
    end
  end # !Stream

  private

  # Find the registered stream from its wrapped IO
  #
  # @param [IO] io
  # @return [Selector::Stream] or nil class if not found
  def find_stream_from_io(io)
    @streams.find { |stream| stream.io == io }
  end

  # Tell if a stream is listening at a given event
  #
  # @param [Selector::Stream] stream
  # @param [Symbole] event_type
  # @return [Boolean]
  def stream_listening?(stream, event_type)
    looking_to_(event_type).include? stream.io
  end

  # Return the array of monitored ios dedicated for this type of events
  #
  # @param [Symbole] event_type
  # @return [Array]
  def looking_to_(event_type)
    self.instance_variable_get("@looking_to_#{event_type}")
  end

  # Add or remove a stream from the array of listening streams
  # monitored for an event depending its status
  #
  # @param [Selector::Stream] stream
  # @param [Symbole] event_type
  # @param [Boolean] status
  def update_stream_monitoring_status(stream, event_type, status)
    ensure_valid_event_type!(event_type)
    if status # monitor it
      # ... unless already done
      unless stream_listening?(stream, event_type)
        looking_to_(event_type) << stream.io
      end

    else # un-monitor it
      puts "before: #{looking_to_(event_type)}" # DEBUG
      looking_to_(event_type).delete stream.io
      puts "after: #{looking_to_(event_type)}" # DEBUG
    end

    nil
  end

  # Ensure validity of the type of event passed.
  # It throws an exception otherwise.
  #
  # @param [Symbole] event_type
  def ensure_valid_event_type!(event_type)
    unless MONITORABLE_EVENT_TYPES.include? event_type
      raise "Unvalid event type '#{event_type}'."
    end
  end
end
