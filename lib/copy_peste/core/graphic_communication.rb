class GraphicCom

  attr_accessor :exec

  @@codes = {
    :core => 10,
    :analysis => 20,
    :display => 0,
    :info => 1,
    :error => 2,
    :cmd_return => 3
  }

  def initialize (exec_func)
    @exec = exec_func
  end

  def self.codes
    @@codes
  end

  def cmd_return (cmd, output, isError)
    format_hash = {
      :code => @@codes[:core] + @@codes[:cmd_return],
      :data => {
        :cmd => cmd,
        :output => output,
        :isError => isError
        },
      }
    @exec.call format_hash
  end

  def error (from, error_code, error_msg)
    format_hash = {
      :code => from + @@codes[:error],
      :data => {
        :error_code => error_code,
        :error_msg => error_msg
        },
      }
    @exec.call format_hash
  end

  def info (from, output)
    format_hash = {
      :code => from + @@codes[:info],
      :data => {
        :output => output
        },
      }
    @exec.call format_hash
  end

  def display (from, output)
    format_hash = {
      :code => from + @@codes[:display],
      :data => {
        :output => output
        },
      }
    @exec.call format_hash
  end


end