require 'csv'
require './lib/constants'
require './lib/curl_parser'

module ActivityLogger
  def log_activity
    datetime = DateTime.now
    CSV.open(LOGFILE_PATH, File::WRONLY | File::APPEND | File::CREAT) do |csv|
      if FILE_OPS.include?(@action)
        # process_name - do we want the script's process name, or process_name of the executed command?
        csv << [
          "timestamp: #{datetime.to_s}", "action: #{@action}","file_path: #{@file_path}", "user: #{@user}",
          "process_name: #{$PROGRAM_NAME}", "command_line: #{@command_line}","pid: #{@pid}"
        ]
      elsif @action == NETWORK
        network = CurlParser.new
        csv << [
          "timestamp: #{datetime.to_s}", "action: #{@action}", "user: #{@user}", "process_name: #{$PROGRAM_NAME}",
          "source_address: #{network.source_address}:#{network.source_port}", "protocol: #{network.protocol}",
          "destination_address: #{network.destination_address}:#{network.destination_port}",
          "data_sent: #{network.amt_data_sent} bytes", "command_line: #{@command_line}", "pid: #{@pid}"
        ]
      else
        csv << [
          "timestamp: #{datetime.to_s}", "action: #{@action}", "user: #{@user}",
          "process_name: #{$PROGRAM_NAME}", "command_line: #{@command_line}", "pid: #{@pid}"
        ]
      end
    end
  end
end
