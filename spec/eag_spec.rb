require './eag.rb'
require 'pry'

RSpec.describe EAG do
  context 'starting processes' do
    it 'should start a process given a path' do
      # make forrest executable
      system %(chmod +x spec/concerns/forrest)

      expect { EAG.start_process('./spec/concerns/forrest') }
        .to output(a_string_including("Look ma!  I'm running!"))
          .to_stdout_from_any_process
    end
  end
end
