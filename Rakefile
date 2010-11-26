
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

desc 'Default task (test)'
task :default => [:test]

desc 'Run unit tests'
Rake::TestTask.new('test') do |test|
  test.pattern = 'test/*.rb'
  test.warning = true
end

task :gem
spec = eval( File.read('csvobj.gemspec') )
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

desc 'Generate rdoc'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'csvobj.rb'
  rdoc.options << '--line-numbers'
  rdoc.options << '--inline-source'
  rdoc.options << '-A cattr_accessor=object'
  rdoc.options << '--charset' << 'utf-8'
  rdoc.options << '--all'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/csvobj.rb')
  rdoc.rdoc_files.include( Dir.glob( File.join('test', '*.rb') ) )
end

