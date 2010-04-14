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

Then /^it fails$/ do
  @last_exit_status.should_not == 0
end

Then /^it succeeds$/ do
  @last_exit_status.should == 0
end

Then /^"([^\"]*)" exists$/ do |file|
  File.exist?(file).should == true
end

Then /^the error text is "([^\"]*)"$/ do |text|
  @last_stderr.chomp.should == text
end

def check_header(header, exists, verdict)
  File.exist?("#{HCACHE_DIR}/#{header}").should == exists
  @last_stdout.match(/#{verdict}.*#{header}/).should_not == nil
end

Then /^"([^\"]*)" is a hit$/ do |header|
  check_header(header, true, "HIT")
end

Then /^"([^\"]*)" is a miss$/ do |header|
  check_header(header, true, "MISS")
end

Then /^"([^\"]*)" is relative$/ do |header|
  check_header(header, false, "RELATIVE")
end

Then /^"([^\"]*)" is uncached$/ do |header|
  check_header(header, true, "UNCACHED")
end

