HCACHE_DIR = "hcache-dir"

Before do
  Dir.chdir("examples")
  ENV["HCACHE_DIR"] = HCACHE_DIR
end

After do
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

