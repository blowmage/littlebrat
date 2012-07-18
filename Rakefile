require 'rake'
require 'rake/clean'

require 'rubygems'
require 'rubygems/package_task'

gemspec = eval(File.read('littlebrat.gemspec'))

Gem::PackageTask.new(gemspec) do |pkg|
  # pkg.need_zip = true
  # pkg.need_tar = true
end

require 'rdoc/task'
rd = Rake::RDocTask.new("rdoc") do |rdoc|
  rdoc.title = "#{gemspec.name} (#{gemspec.version}) - #{gemspec.description}"
  rdoc.options << '--line-numbers --inline-source --main README'
  rdoc.rdoc_files.include(gemspec.files)
  rdoc.main = 'README'
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort 'RCov is not available. In order to run rcov, you must: gem install rcov'
  end
end

# task :test => :check_dependencies