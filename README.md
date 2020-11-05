# Endpoint Activity Generator

## Project Structure
* `eag.rb` is the program's main entry point and contains all of its externally available tasks/functions
* `/lib` contains:
  * `curl_parser.rb`, a class for parsing `curl` outputs;
  * `activity_logger.rb` the module responsible for logging activity;
  * `constants.rb` which contains the programs constants.
* `/spec` contains the programs tests and test fixtures (in `spec/concerns`)
* `/logs` is initially empty, but will contain two files after running all tasks

The only dependencies outside of Ruby's Standard Library are:
1. RSpec for testing
2. Rake for executing tasks

## Setup
1. `bundle install`
2. `rspec spec` (optional, run the tests)

## Execution
1. From terminal using Rake (commands covered below)
2. From terminal using RSpec (executes all commands and creates logs)
3. From `irb` by requring `eag.rb`

# Rake Commands
Example:  `rake task_name["arg1","arg2","arg3"]`
* all of the examples below can by copy/paste executed in the terminal, unless you use `zsh` (see gotchas)

## Two major gotchas for providing Rake with arguments
1. No spaces after commas. e.g. ["1","2","3"] NOT ["1", "2", "3"]
2. If using `zsh`, you must escape the brackets with \\. e.g. `rake start_process\["path/to/exec/"\]`

## start_process
Takes either:
1. path to an executable
2. terminal command (e.g. `open -a Calculator`)

Example: `rake start_process["open -a Calculator"]`

## create_file
Takes three parameters:
1. Path where to create the file, can be relative or absolute
2. File name
3. Extension of the file preceded by "." e.g ".txt"

Example: `rake create_file["./","foobar",".txt"]`


## update_file
Takes two parameters
1. Path to file
2. Content string to add to file.

Example: `rake update_file["./foobar.txt","Updating the file."]`


## delete_file
Takes one parameter
1. path of file

Example: `rake delete_file("./foobar.txt")`


## connect
Takes one parameter
1. URL
 * really you can send it anything you'd normally send `curl` such as flags

Example: `rake connect["https://www.google.com"]`


## end_to_end
Takes zero parameters
* Runs each of the previous tasks in succession
* Opens /logs directory when finished

Example: `rake end_to_end`

# Known issues
* Process name will be whatever is executing the program (e.g. RSpec, Rake, IRB)
* I wasn't sure if the PID should be from what is doing the executing (e.g. Rake, IRB) or what is being executued (e.g. Calculator.app). So the PID belongs to what is being executed (e.g. Calculutor.app)
* Network activity was by far the most difficult portion for me, as such, the source address (but not port) and protocol are hardcoded.  The network portion is the most brittle part of the application.
* Has not been tested on, nor do I think it will work on Windows.
