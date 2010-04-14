require File.dirname(__FILE__) + '/../lib/hcache/config'

include Hcache

describe Config do

  it "allows an empty file" do
    config = Config.new("")
    config.included.should == /.*/
  end

  it "allows newlines" do
    config = Config.new("^\/foo\n\n")
    config.included.match("/foo/bar").should_not == nil
  end

end

