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

def header_is_verdict(header, verdict)
  File.exist?("#{HCACHE_DIR}/#{header}").should == true
  @last_stdout.match(/#{verdict}.*#{header}/).should_not == nil
end

Then /^"([^\"]*)" is a hit$/ do |header|
  header_is_verdict(header, "HIT")
end

Then /^"([^\"]*)" is a miss$/ do |header|
  header_is_verdict(header, "MISS")
end

Then /^"([^\"]*)" is uncached$/ do |header|
  header_is_verdict(header, "UNCACHED")
end

