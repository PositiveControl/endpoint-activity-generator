require "./eag.rb"
# Execution from terminal/command-line uses Rake
# Example:  `rake task_name["arg1","arg2","arg3"]`

# Two major gotchas for giving arguments
# 1) No spaces after commas. e.g. [1,2,3] NOT [1, 2, 3]
# If using zsh, you must escape the brackets with \. e.g. rake start_process\[path\]

# start_process
# Takes either:
# 1) path to an executable
# 2) terminal command (e.g. `open -a Calculator`)

# Example: rake start_process["open -a Calculator"]
task :start_process, [:command] do |t, args|
  EAG.new(args[:command]).start_process
end

# create_file
# Takes three parameters:
# 1) Path where to create the file, can be relative or absolute
# 2) File name
# 3) Extension of the file preceded by "." e.g ".txt"

# Example: rake create_file["./","foobar",".txt"]
task :create_file, [:path, :file_name, :file_extension] do |t, args|
  EAG.new(args[:path]).create_file(args[:file_name], args[:file_extension])
end

# update_file
# Takes two parameters
# 1) Path to file
# 2) Content string to add to file.

#Example: rake update_file["./foobar.txt","Updating the file."]
task :update_file, [:path, :content] do |t, args|
  EAG.new(args[:path]).update_file(args[:content])
end

# delete_file
# Takes one parameter
# 1) path of file

# Example: rake delete_file("./foobar.txt")
task :delete_file, [:path] do |t, args|
  EAG.new(args[:path]).delete_file
end

# connect
# Takes one parameter
# 1) URL
# * really you can send it anything you'd normally send `curl` such as flags

# Example: rake connect["https://www.google.com"]
task :connect, [:url] do |t, args|
  EAG.new(args[:url]).connect
end

# end_to_end
# Takes zero parameters
# Runs each of the previous tasks in succession
# Opens /logs directory when finished

# Example: rake end_to_end
task :end_to_end do
  path = "~/"
  file_name = "nefarious"
  file_extension = ".rb"
  full_path = path + file_name + file_extension
  EAG.new(path).create_file(file_name, file_extension)
  puts "File Create: I just created a new file called: #{file_name + file_extension} at #{path}."

  EAG.new(full_path).update_file('puts \"nefarious.txt is being executed!\"')
  puts "File Update: I just updated #{file_name + file_extension} with evil code!"

  puts "Start Process: I'm now running the file I created and updated it."
  EAG.new("ruby #{full_path}").start_process

  EAG.new(full_path).delete_file
  puts "Delete File:  Covering my tracks... #{full_path} has been deleted."

  EAG.new("http://www.markevans.io").connect
  puts "Network Activity: I'm now connecting to my nefarious website."

  EAG.new("open ./logs").start_process
  puts "COMPLETE:  I'm opening the logs directory so you can see everything I've done."
end
