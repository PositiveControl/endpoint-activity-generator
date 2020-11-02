module EAG
  def self.start_process(path, *args)
    system %(#{path})
  end
end
