require 'logger'
require './lib/constants'
require './lib/curl_parser'

module ActivityLogger
  def log_activity
    file = File.open(LOGFILE_PATH, File::WRONLY | File::APPEND | File::CREAT)
    logger = Logger.new(file)
    logger.formatter = proc do |_, datetime, _, msg|
      if FILE_OPS.include?(@action)
        # process_name - do we want the script's process name, or process_name of the executed command?
        "timestamp: #{datetime.to_s},action: #{@action}, file_path: #{@file_path},user: #{@user},process_name: #{$PROGRAM_NAME},command_line: #{@command_line},pid: #{@pid}\n"
      elsif @action == NETWORK
        network = CurlParser.new
        "timestamp: #{datetime.to_s},action: #{@action},user: #{@user},process_name: #{$PROGRAM_NAME},source_address: #{network.source_address}:#{network.source_port},destination_address: #{network.destination_address}:#{network.destination_port},protocol: #{network.protocol},data_sent: #{network.amt_data_sent} bytes,command_line: #{@command_line},pid: #{@pid}\n"
      else
        "timestamp: #{datetime.to_s},action: #{@action},user: #{@user},process_name: #{$PROGRAM_NAME},command_line: #{@command_line},pid: #{@pid}\n"
      end
    end
    logger.info(@path)
    logger.close
  end
end
