require './eag.rb'
require 'csv'
require 'pry'

RSpec.describe EAG do
  let(:username) { Etc.getlogin }
  let(:logs) { File.read('./logs/activity.csv') }
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
    before(:each) do
      EAG.new('./spec/concerns/').create_file('nefarious','.txt')
    end
    after do
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

    xit 'logs process name' do
      # process of script, or process of executed command line?
      expect(logs.include?("file_create")).to be_truthy
    end

    it 'logs full file path' do
      expect(logs.include?(full_nefarious_path)).to be_truthy
    end

    it 'logs file name' do
      expect(logs.include?("nefarious.txt")).to be_truthy
    end

    it 'logs activity descriptor' do
      expect(logs.include?("action: create")).to be_truthy
    end
  end
end
