require 'etc'
require 'open3'
require './concerns/constants'
require './concerns/activity_logger'

class EAG
  include ActivityLogger

  def initialize(path)
    @path = path
    @user = Etc.getlogin
    @pid = nil
    @action = nil
    @command_line = nil
    @file_path = nil
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

  private

  def execute_command
    stdin, stdout, thread = Open3.popen2(@command_line)
    @pid = thread.pid
    log_activity
    # puts is only for spec expectation
    puts stdout.read
    [stdin, stdout].each(&:close)
  end
end
