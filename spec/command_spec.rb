require File.join(File.dirname(__FILE__), '../lib/hcache/command')

include Hcache

describe CommandBase do

  ARGS = ['foo', 'bar']
  HCACHE_DIR = 'baz/'
  GCC_DEFAULT_INCLUDES = ['qux', 'quux']

  it "expands GCC default includes" do
    command = CommandBase.new(ARGS, HCACHE_DIR, GCC_DEFAULT_INCLUDES)
    command.to_s.should == "foo -Ibaz/qux -Ibaz/quux"
  end

end

describe DependencyCommand do

  ARGS = ['foo', '-Ibar', '-o', 'baz.o', 'baz.c']
  HCACHE_DIR = 'qux/'
  GCC_DEFAULT_INCLUDES = []
  
  it "removes -o option and adds -M and -MP options" do
    command = DependencyCommand.new(ARGS, HCACHE_DIR, GCC_DEFAULT_INCLUDES)
    command.to_s.should == "foo -Iqux/bar baz.c -M -MP -Ibar"
  end

end

