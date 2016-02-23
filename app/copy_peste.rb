require "json"
require "socket"
require "../libs/app/threads_communication/selector"
require "../libs/app/dynamic_loading/module_loader"

def path_to_graphics_module(module_name)
  "../modules/graphics/#{module_name}.rb"
end

class CopyPeste

  def self.run
    instance.run
    self
  end

  def self.config(options = {})
    #
    self
  end

  def run
    starting_server

    @command_queue << Command.new do |c|
      c.action = "load"
      c.name = "default"
      c.type = "ui"
    end
    @command_queue << Command.new do |c|
      c.action = "run"
      # c.name = "default"
      # c.type = "ui"
    end

    @selector.loop(@command_queue) do |selector, co_queue|
      unless co_queue.empty?
        command = co_queue.shift
        execute_command command
      end

      # something else?
    end
  end

  private

  def self.new(*args, &blk)
    super(*args, &blk)
  end

  def self.instance
    @@instance ||= new
  end

  def initialize
    @module_instance_manager = ModuleInstanceManager.new
    @command_queue = []
  end

  # Si j'arrive à virer dans Selector tous les streams enregistrés sauf
  # ceux sur lesquels on ne peut pas read, alors tout ça peut retourner
  # dans initialize plutot qu'être au début du run()
  def starting_server
    @selector = Selector.new
    server = @selector.register_io TCPServer.new("0.0.0.0", 4242)
    server.is_accepting!
    server.callback_for_read(
      @selector,
      @module_instance_manager,
      @command_queue
    ) do |server, selector, module_instance_manager, command_queue|
      peer, _ = server.io.accept
      peer = selector.register_io peer
      module_instance_manager.complete_pending peer
      peer.callback_for_read do |peer|
        command_queue << Command.from_json(
          peer.dequeue,
          module_instance_manager.find_by_stream(peer)
        )
      end
      peer.callback_for_close { |peer| } # ??

      peer.listen :read
    end # !callback_for_read

    server.callback_for_close() do |peer|
    end

    server.listen :read
  end

  def execute_command(command)
    case command.action
    when "load"
      # check either or not the source of the command is granted to do it
      path = path_to_graphics_module(command.name)
      loaded_module = ModuleLoading::Loader.load path
      @module_instance_manager.create_new_one loaded_module

    when "run"
      # check that the loaded_module is not already running!
      (command.module_instance_source || @module_instance_manager.on_startup).run

    when "say"
      command.module_instance_source.stream.queue(
        Command.new() do |c|
          c.action = "say"
          c.name = "Pong '%s'." % command.name
        end.to_json
      )

    when "stop"
      # shut down everything
      # check either or not the source of the command is granted to do it
      # join() the thread

    when "done"
      command.module_instance_source.terminate!
    end
  end

  class ModuleInstance
    attr_reader :stream, :loaded_module

    def pending?
      !@stream
    end

    def first?
      @is_first
    end

    # Set the server-side client stream
    #
    def stream=(stream)
      @stream = stream if pending?
    end

    def name;        @loaded_module.__cp_name__        end
    def usage;       @loaded_module.__cp_usage__       end
    def author;      @loaded_module.__cp_author__      end
    def description; @loaded_module.__cp_description__ end
    def run
      raise if !first? && pending?
      @thread = Thread.new do
        entry_point = @loaded_module.__cp_init__
        selector = Selector.new(5)
        client = selector.register_io TCPSocket.new("0.0.0.0", 4242)
        stdin = selector.register_io STDIN

        # Defining callbacks for the client-side server stream
        client.callback_for_read do |cl|
          entry_point._callback_for_read(cl)
        end

        client.callback_for_write do |cl|
          entry_point._callback_for_write(cl)
        end

        client.callback_for_close do |_|
          puts "Connection closed by the server"
          exit
        end

        # Defining callbacks for the client-side standard entry stream
        stdin.callback_for_read(client) do |stdin, client|
          action, params = stdin.dequeue.split(' ', 2)
          client.queue(
            Command.new do |co|
              co.action = action
              co.name = params
            end.to_json
          )
        end

        # Starting to listen on the streams
        client.listen :read
        stdin.listen :read

        # Loop
        selector.loop { |selector|
          entry_point._loop(selector)
        }

        # Later on, for the analysis modules, do so:
        # selector.loop do |selector|
        #   entry_point._loop(selector)
        #   selector.must_stop!
        # end

        # Telling the server the execution is done
        client.queue Command.new do |co|
          co.action = "done"
        end.to_json
      end
    end

    def terminate!
      if @thread
        @thread.terminate
        @thread.join
      end

      @thread = nil
    end

    private

    def initialize(loaded_module, is_first = false, &block)
      @loaded_module = loaded_module
      @is_first = is_first
      yield self if block_given?
      super()
    end
  end

  class ModuleInstanceManager
    def complete_pending(stream)
      raise "Was not waiting for module to connect" unless one_pending?
      module_instance, @pending = @pending, nil
      module_instance.stream = stream
      @module_instances << module_instance
      module_instance
    end

    def create_new_one(loaded_module, &block)
      raise "Already one module pending" if one_pending?
      @pending = ModuleInstance.new(
        loaded_module,
        @module_instances.empty?,
        &block
      )
    end

    def one_pending?
      !!@pending
    end

    def find_by_stream(stream)
      index = @module_instances.find_index { |mi| mi.stream == stream }
      @module_instances.at index if index
    end

    # Hack :'(
    #
    def on_startup
      raise unless @module_instances.empty?
      @pending
    end

    private

    def initialize(&block)
      @module_instances = []
      @pending = nil
      yield self if block_given?
    end
  end

  class Command
    attr_accessor :action, :type, :name, :module_instance_source

    def self.json_create(o, *args)
      new(*args) do |c|
        c.action = o["data"]["action"]
        c.type = o["data"]["type"]
        c.name = o["data"]["name"]
      end
    end

    def self.from_json(json, *args)
      json_create JSON.parse(json), *args
    end

    def to_json
      {
        json_class: self.class.name,
        data: {
          action: @action,
          type: @type,
          name: @name,
        }
      }.to_json
    end

    private

    def initialize(module_instance_source = nil, &block)
      @module_instance_source = module_instance_source
      yield self if block_given?
    end
  end
end

CopyPeste.config(
  log_file: "#{Time.now.strftime('%Y%m%d%H%M%S')}.copypeste.log",
)
CopyPeste.run
