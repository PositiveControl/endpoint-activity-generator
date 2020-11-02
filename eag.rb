require 'logger'

module EAG
  def self.start_process(command)
    pid = spawn(command)
    Process.wait(pid)
    log_activity(Etc.getlogin, pid, command)
  end

  private

  def self.log_activity(user, pid, command)
    file = File.open('logs/activity.csv', File::WRONLY | File::APPEND | File::CREAT)
    logger = Logger.new(file)
    logger.formatter = proc do |_, datetime, _, msg|
        "timestamp: #{datetime.to_s},user: #{user},process_name: #{$PROGRAM_NAME},command_line: #{msg},pid: #{pid}\n"
    end
    logger.info(command)
    logger.close
  end
end
