# frozen_string_literal: true
source 'https://rubygems.org'

group :rake do
  gem 'rake'
end

group :lint do
  gem 'foodcritic', '~> 6.1'
  gem 'rubocop', '~> 0.39'
  gem 'rubocop-checkstyle_formatter'
end

group :unit, :integration do
  gem 'chef', '~> 12.9'
  gem 'cheffish', '~> 2.0'
  gem 'chefspec', '~> 5.0'
  gem 'minitest', '~> 5.0'
  gem 'rspec_junit_formatter'
end

group :kitchen_common do
  gem 'berkshelf', '~> 4.0'
  gem 'inspec', '~> 1.6.0'
  gem 'kitchen-inspec'
  gem 'kitchen-sync'
  gem 'kitchen-transport-sshtar'
  gem 'test-kitchen', git: 'git@github.intuit.com:SBG/test-kitchen.git'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant'
end

group :ec2 do
  gem 'kitchen-ec2', git: 'git@github.intuit.com:SBG/kitchen-ec2.git'
end
