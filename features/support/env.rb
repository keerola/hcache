require 'tempfile'
require 'spec/expectations'

class HcacheWorld
  
  def run(command)
    stderr_file = Tempfile.new('hcache-world')
    stderr_file.close
    @last_stdout = `#{command} 2> #{stderr_file.path}`
    @last_exit_status = $?.exitstatus
    @last_stderr = IO.read(stderr_file)
  end
  
end

World do
  HcacheWorld.new
end

