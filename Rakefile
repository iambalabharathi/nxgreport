require 'rake/testtask'
require "bundler/gem_tasks"


task :default => :spec

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*.rb']
  t.verbose = true
end
