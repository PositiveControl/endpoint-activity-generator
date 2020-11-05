require './lib/constants'

class CurlParser
  attr_accessor :source_address, :source_port, :destination_address,
                :destination_port, :protocol, :amt_data_sent

  def initialize(file_path=nil)
    @file_path = file_path
    self.protocol = "TCP"
    self.source_address = "127.0.0.1"
    self.source_port = nil
    self.destination_address = nil
    self.destination_port = nil
    self.amt_data_sent = nil
    set_source
    set_destination
    set_data_sent
  end

  def set_source
    self.source_port = output_file
      .grep(/Local port: \d{2,}/)
      .take(1)
      .first
      .scan(/\d{2,}/)
      .first
  end

  def set_destination
    destination_string = output_file.grep(/port \d{2,}/).take(1).first
    self.destination_port = destination_string
      .scan(/port \d{2,}/)
      .first
      .scan(/\d{2,}/)
      .first

    self.destination_address = destination_string.scan(/www.\w{2,}.com/).first
  end

  def set_data_sent
    total_sent = 0
    output_file.grep(/\[\d{2,} bytes data\]/).each do |str|
      amount = str.scan(/\d{2,}/).first.to_i
      total_sent += amount
    end
    self.amt_data_sent = total_sent
  end

  def output_file
      IO.foreach(@file_path || NETWORKLOG_PATH, encoding: 'ISO-8859-1')
  end
end
