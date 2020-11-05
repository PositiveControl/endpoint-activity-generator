require './lib/constants'
require './eag.rb'

RSpec.describe EAG do
  let(:username) { Etc.getlogin }
  let(:logs) { File.read("./#{LOGFILE_PATH}") }
  let(:forrest_path) { './spec/concerns/forrest' }
  let(:nefarious_path) { './spec/concerns/nefarious.txt' }

  before(:all) do
    # make forrest executable
    system %(chmod +x './spec/concerns/forrest')
  end

  context 'starting processes' do
    it 'should start a process given a path' do
      expect { EAG.new(forrest_path).start_process }
        .to output(a_string_including("Look ma!  I'm running!"))
          .to_stdout_from_any_process
    end
  end

  context 'file operations' do
    before(:all) do
      EAG.new('./spec/concerns/').create_file('nefarious','.txt')
    end
    after(:all) do
      # cleanup created file
      # sleep to allow expectation to finish before after block is called
      sleep(0.1)
      system %(rm './spec/concerns/nefarious.txt')
    end

    it 'creates a new file given a path' do
      expect(File.exist?(nefarious_path)).to be_truthy
    end

    it 'updates file at given path' do
      EAG.new(nefarious_path).update_file("You are being hacked!")

      expect(File.read(nefarious_path)).to include("You are being hacked!")
    end

    it 'deletes file at given path' do
      EAG.new(nefarious_path).delete_file

      expect(File.exist?(nefarious_path)).to be_falsey
    end
  end

  context 'logging process start' do
    it 'should log user who started the process' do
      EAG.new(forrest_path).start_process

      expect(logs.include?(username)).to be_truthy
    end
  end

  context 'logging file operations'do
    before(:all) do
      EAG.new('./spec/concerns/').create_file('nefarious','.txt')
    end

    after(:all) do
      sleep(0.1)
      system %(rm ./spec/concerns/nefarious.txt)
    end

    let(:full_nefarious_path) { File.expand_path('./spec/concerns/nefarious.txt') }

    it 'logs full file path' do
      expect(logs.include?(full_nefarious_path)).to be_truthy
    end

    it 'logs file name' do
      expect(logs.include?("nefarious.txt")).to be_truthy
    end

    it 'logs create activity descriptor' do
      expect(logs.include?("action: #{CREATE}")).to be_truthy
    end

    it 'logs update activity descriptor' do
      EAG.new(nefarious_path).update_file("You are being hacked!")

      expect(logs.include?("action: #{UPDATE}")).to be_truthy
    end

    it 'logs delete activity descriptor' do
      EAG.new(nefarious_path).delete_file

      expect(logs.include?("action: #{DELETE}")).to be_truthy
    end
  end

  context 'logging network activity' do
    before(:all) do
      EAG.new("https://www.google.com").connect
    end

    it 'logs the destination address and port' do
      expect(logs.include?("www.google.com:443")).to be_truthy
    end

    it 'logs the source address and port' do
      expect(logs.include?("127.0.0.1:3001")).to be_truthy
    end

    it 'logs the protocol' do
      expect(logs.include?("TCP")).to be_truthy
    end

    it 'logs the total data sent' do
      # hacky way of ensuring data sent is present
      # because amount changes with every connection
      data_sent = File
        .foreach("./#{LOGFILE_PATH}")
        .grep(/\d{2,} bytes/)
        .take(1)
        .first

      expect(data_sent).to be_truthy
    end
  end
end
