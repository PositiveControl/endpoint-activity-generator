require 'logger'
require 'etc'
require 'open3'

class EAG
  def initialize(path)
    @path = path
    @user = Etc.getlogin
    @pid = nil
    @action = nil
    @command_line = nil
    @file_path = nil
  end

  def start_process
    @action = "start_process"
    @command_line = @path
    execute_command
  end

  def create_file(name, extension)
    @action = "create"
    @file_path = File.expand_path(@path + name + extension)
    @command_line = "touch #{@file_path}"
    execute_command
  end

  def update_file(content)
    @action = "update"
    @file_path = File.expand_path(@path)
    @command_line = "echo #{content} >> #{@file_path}"
    execute_command
  end

  def delete_file
    @action = "delete"
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

  def process_name
    # "/" wont work on Windows
    @path.split("/").last
  end

  def file_operations
    # set as constants
    ["create", "update", "delete"]
  end

  # pull out into module and include
  def log_activity
    file = File.open('logs/activity.csv', File::WRONLY | File::APPEND | File::CREAT)
    logger = Logger.new(file)
    logger.formatter = proc do |_, datetime, _, msg|
      if file_operations.include?(@action)
        # process_name - do we want the script's process name, or process_name of the executed command?
        "timestamp: #{datetime.to_s},action: #{@action}, file_path: #{@file_path},user: #{@user},process_name: #{$PROGRAM_NAME},command_line: #{@command_line},pid: #{@pid}\n"
      else
        "timestamp: #{datetime.to_s},action: #{@action},user: #{@user},process_name: #{process_name},command_line: #{@command_line},pid: #{@pid}\n"
      end
    end
    logger.info(@path)
    logger.close
  end
end
