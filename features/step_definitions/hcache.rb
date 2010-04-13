Given /^working directory "([^\"]*)"$/ do |directory|
  Dir.chdir(directory)
end

When /^I run "([^\"]*)"$/ do |command|
  run command
end

Then /^it succeeds$/ do
  @last_exit_status.should == 0
end

Then /^"([^\"]*)" exists$/ do |file|
  File.exist?(file).should == true
end

