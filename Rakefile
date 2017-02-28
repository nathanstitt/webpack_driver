require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/**/test_*.rb']
end
desc "Run tests"

task :console do
  require 'irb'
  require 'irb/completion'
  require_relative './lib/webpack_driver'
  ARGV.clear
  IRB.start
end

task :default => :test
