require File.join(File.dirname(__FILE__), '../lib/hcache/app')

include Hcache

describe App, "#get_cache_dir" do

  before do
    ENV.clear
  end

  it "returns $HCACHE_DIR by default" do
    ENV["HCACHE_DIR"] = 'foo'
    ENV["HOME"] = 'bar'
    App.get_cache_dir.should == 'foo/'
  end

  it "does not append a slash to $HCACHE_DIR if it has one" do
    ENV["HCACHE_DIR"] = 'foo/'
    App.get_cache_dir.should == 'foo/'
  end

  it "returns $HOME/.hcache/ if $HCACHE_DIR is not defined" do
    ENV["HOME"] = 'foo'
    App.get_cache_dir.should == 'foo/.hcache/'
  end

  it "returns nil if neither $HCACHE_DIR nor $HOME are defined" do
    App.get_cache_dir.should == nil
  end

end

