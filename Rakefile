require 'cucumber/rake/task'
require 'spec/rake/spectask'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--no-source"
end

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ["--color", "--format=nested"]
end

task :default => [:spec, :features]

