require 'tty-table'
require File.join(
  CopyPeste::Require::Path.graphics,
  'console_mode',
  'console_display'
)

class CoreRequests < ConsoleDisplay

  # Parse and execute a Hash returned by the Core.
  #
  # @param hash [Hash] hash containing a task to be treated by graphical module.
  def exec(hash)
    if hash[:code] % 10 == 0
      puts "#{hash[:data][:output]}"

    elsif hash[:code] % 10 == 1 && @@debug == true
      puts "[info][Core] #{hash[:data][:output]}".green

    elsif hash[:code] % 10 == 2
      puts "[error][Core] #{hash[:data][:output]}".red

    elsif hash[:code] % 10 == 3
      if hash[:data][:isError]
        puts "[error][Core] Command fail: #{hash[:data][:output]}".red
        return
      end

      if hash[:data][:cmd] == "use_analysis_module"
        @@prompt = "cp (#{hash[:data][:output].red}) > "

      elsif hash[:data][:cmd] == "exit_analysis_module"
        @@prompt = "cp > "

      elsif hash[:data][:cmd] == "show_analysis_mod_options"
        cmd_show_analysis_mod_options hash

      elsif hash[:data][:cmd] == "list_analysis_modules"
        cmd_list_analysis_modules hash

      elsif hash[:data][:cmd] == "help"
        cmd_help hash

      elsif hash[:data][:cmd] == "generate_result"
        puts hash[:data][:output]

      elsif hash[:data][:cmd] == "list_result"
        puts hash[:data][:output]

      elsif hash[:data][:cmd] == "init_db"
        puts hash[:data][:output]

      elsif hash[:data][:cmd] == "current_module_info"
        puts hash[:data][:output]

      end
    end
  end

  private

  # Execute and display information returned by the core after executing
  # the show_analysis_mod_options command.
  #
  # @param hash [Hash] formatted hash containing command's results to be displayed.
  def cmd_show_analysis_mod_options(hash)
    column_names = [
      'option',
      {
        value: 'description',
        alignment: :center
      },
      'current value',
      'allowed values'
    ]
    lines = []
    line = []
    hash[:data][:output].each do |opt, data|
      data[:allowed].length > 5 ?
        (allowed = "#{data[:allowed].first} to #{data[:allowed].last}") :
        (allowed = data[:allowed])
      line = [opt, data[:helper], data[:value], allowed]
      lines.push line
    end

    table = TTY::Table.new column_names, lines
    puts table.render(:ascii, alignments: [:center, :left, :center, :center])
  end

  # Execute and display information returned by the core after executing
  # the list_analysis_modules command.
  #
  # @param hash [Hash] formatted hash containing command's results to be displayed.
  def cmd_list_analysis_modules(hash)
    column_names = ['Availables analysis modules']
    lines = []
    hash[:data][:output].each do |mod|
      line = [mod]
      lines.push line
    end

    table = TTY::Table.new column_names, lines
    puts table.render(:ascii, alignment: [:center])
  end

  # Execute and display information returned by the core after executing
  # the help command.
  #
  # @param hash [Hash] formatted hash containing command's results to be displayed.
  def cmd_help(hash)
    column_names = ['Commands', 'Help']
    lines = []
    hash[:data][:output].each do |cmd, helper|
      line = [cmd, helper]
      lines.push line
    end

    table = TTY::Table.new column_names, lines
    puts table.render(:ascii, alignment: [:left])
  end

end
