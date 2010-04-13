Before do
  Dir.chdir("examples")
end

After do
  Dir.chdir("..")
end

Given /^empty cache "([^\"]*)"$/ do |cache|
  ENV["HCACHE_DIR"] = cache
  FileUtils.rm_rf(cache)
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

