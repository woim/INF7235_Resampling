# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','resampling','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'resampling'
  s.version = Resampling::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','resampling.rdoc']
  s.rdoc_options << '--title' << 'resampling' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'resampling'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_runtime_dependency('gli','2.14.0')
  s.add_runtime_dependency('chunky_png')
  s.add_runtime_dependency('minitest')
end
