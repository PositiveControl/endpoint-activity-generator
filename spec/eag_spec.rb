require './eag.rb'
require 'csv'
require 'pry'

RSpec.describe EAG do
  before do
    # make forrest executable
    system %(chmod +x spec/concerns/forrest)
  end

  context 'starting processes' do
    it 'should start a process given a path' do
      expect { EAG.new('./spec/concerns/forrest').start_process }
        .to output(a_string_including("Look ma!  I'm running!"))
          .to_stdout_from_any_process
    end
  end

  context 'logging activity' do
    it 'should log user who started the process' do
      username = Etc.getlogin
      EAG.new('./spec/concerns/forrest').start_process
      logs = File.read('./logs/activity.csv')

      expect(logs.include?(username)).to be_truthy
    end
  end
end
