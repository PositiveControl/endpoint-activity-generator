require './lib/constants'
require './lib/curl_parser'
require 'pry'

RSpec.describe CurlParser do
  context 'parsing curl output' do
    let!(:curl_parser) { CurlParser.new(TEST_NETWORKLOG_PATH) }

    it 'assigns source port' do
      expect(curl_parser).to have_attributes(:source_port => "3001")
    end

    it 'assigns destination port' do
      expect(curl_parser).to have_attributes(:destination_port => "443")
    end

    it 'assigns destination address' do
      expect(curl_parser).to have_attributes(:destination_address => "www.google.com")
    end

    it 'assigns protocol' do
      expect(curl_parser).to have_attributes(:protocol => "TCP")
    end

    it 'assigns amount of data sent' do
      expect(curl_parser).to have_attributes(:amt_data_sent => 4028)
    end
  end
end
