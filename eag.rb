require 'etc'
require 'open3'
require './lib/constants'
require './lib/activity_logger'

class EAG
  include ActivityLogger

  def initialize(path)
    @path = path
    @user = Etc.getlogin
    @pid, @action, @command_line, @file_path, @stdout = nil
  end

  def start_process
    @action = START_PROCESS
    @command_line = @path
    execute_command
  end

  def create_file(name, extension)
    @action = CREATE
    @file_path = File.expand_path(@path + name + extension)
    @command_line = "touch #{@file_path}"
    execute_command
  end

  def update_file(content)
    @action = UPDATE
    @file_path = File.expand_path(@path)
    @command_line = "echo #{content} >> #{@file_path}"
    execute_command
  end

  def delete_file
    @action = DELETE
    @file_path = File.expand_path(@path)
    @command_line = "rm #{@file_path}"
    execute_command
  end

  def connect
    @action = NETWORK
    @command_line = "curl --local-port 3001 #{@path} -v > #{NETWORKLOG_PATH} 2>&1"
    execute_command
  end

  private

  def execute_command
    stdin, stdout, thread = Open3.popen2(@command_line)
    @stdout = stdout.read
    # pid of executed process, NOT this program that executed it
    @pid = thread.pid
    log_activity
    # puts is only for spec expectation
    puts @stdout
    [stdin, stdout].each(&:close)
  end
end
