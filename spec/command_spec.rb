require File.join(File.dirname(__FILE__), '../lib/hcache/command')

include Hcache

describe Command do

  before do
    @args = ['foo', 'bar']
    @hcache_dir = 'baz/'
    @gcc_default_includes = ['qux', 'quux']
  end

  it "expands GCC default includes" do
    command = Command.new(@args, @hcache_dir, @gcc_default_includes)
    command.to_s.should == "foo -Ibaz/qux -Ibaz/quux"
  end

end

describe CompileCommand do

  before do
    @args = ['foo', '-Ibar', '-c', '-o', 'baz.o', 'baz.c']
    @hcache_dir = 'qux/'
    @gcc_default_includes = []
  end

  it "prefers cached include directories" do
    command = CompileCommand.new(@args, @hcache_dir, @gcc_default_includes)
    command.to_s.should == "foo -Iqux/bar -c -o baz.o baz.c -Ibar"
  end

end

describe DependencyCommand do

  before do
    @args = ['foo', '-Ibar', '-c', '-o', 'baz.o', 'baz.c']
    @hcache_dir = 'qux/'
    @gcc_default_includes = []
  end
  
  it "removes -o option and adds -M and -MP options" do
    command = DependencyCommand.new(@args, @hcache_dir, @gcc_default_includes)
    command.to_s.should == "foo -Iqux/bar -c baz.c -M -MP -Ibar"
  end

end

