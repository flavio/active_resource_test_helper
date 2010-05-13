require 'rake'
require 'rake/testtask'

task :default => "test"

namespace :test do
  desc "Test all classes"
  Rake::TestTask.new(:all) do |t|
    t.libs << "test"
    t.pattern = 'test/*_test.rb'
    t.verbose = true
  end 
end

desc "run all the unit tests"
task :test do
  Rake::Task["test:all"].invoke
end
