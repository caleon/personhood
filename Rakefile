# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "Personhood"
  gem.homepage = "http://github.com/caleon/personhood"
  gem.license = "MIT"
  gem.summary = %Q{ActiveRecord abstraction for attributes pertaining to a person-like model}
  gem.description = <<-DESC
    When you are tired of coding the same kinds of things for your User model
    (or any other person-like model) with all its typical `first_name`,
    `full_name`, and other brouhaha, use the Personhood gem to clean up your
    code by getting rid of those pesky lines and instead focusing on the lines of
    code that *truly* set your app apart.
  DESC
  gem.email = "caleon@gmail.com"
  gem.authors = ["caleon"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Personhood #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
