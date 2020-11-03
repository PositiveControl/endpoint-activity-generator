require 'logger'
require 'etc'
require 'open3'

class EAG
  def initialize(path)
    @path = path
    @user = Etc.getlogin
    @pid = nil
  end

  def start_process
    stdin, stdout, thread = Open3.popen2(@path)
    @pid = thread.pid
    log_activity
    puts stdout.read
    [stdin, stdout].each(&:close)
  end

  private

  def process_name
    @path.split("/").last
  end

  def log_activity
    file = File.open('logs/activity.csv', File::WRONLY | File::APPEND | File::CREAT)
    logger = Logger.new(file)
    logger.formatter = proc do |_, datetime, _, msg|
        "timestamp: #{datetime.to_s},user: #{@user},process_name: #{process_name},command_line: #{msg},pid: #{@pid}\n"
    end
    logger.info(@path)
    logger.close
  end
end
