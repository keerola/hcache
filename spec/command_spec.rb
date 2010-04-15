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

