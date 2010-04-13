HCACHE_DIR = "hcache-dir"

Before do
  Dir.chdir("examples")
  ENV["HCACHE_DIR"] = HCACHE_DIR
  `make clean`
end

After do
  `make clean`
  FileUtils.rm_rf(HCACHE_DIR)
  Dir.chdir("..")
end

When /^I run "([^\"]*)"$/ do |command|
  run command
end

Then /^it says "([^\"]*)"$/ do |regexp|
  @last_stdout.match(regexp).should_not == nil
end

Then /^it succeeds$/ do
  @last_exit_status.should == 0
end

Then /^"([^\"]*)" exists$/ do |file|
  File.exist?(file).should == true
end

Then /^"([^\"]*)" is a hit$/ do |header|
  File.exist?("#{HCACHE_DIR}/#{header}").should == true
  @last_stdout.match(/HIT.*#{header}/).should_not == nil
end

Then /^"([^\"]*)" is a miss$/ do |header|
  File.exist?("#{HCACHE_DIR}/#{header}").should == true
  @last_stdout.match(/MISS.*#{header}/).should_not == nil
end

Then /^"([^\"]*)" is uncached$/ do |header|
  File.exist?("#{HCACHE_DIR}/#{header}").should == true
  @last_stdout.match(/UNCACHED.*#{header}/).should_not == nil
end

