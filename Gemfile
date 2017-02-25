source 'https://rubygems.org'

group :rake do
  gem 'rake'
end

group :lint do
  gem 'rubocop', '~> 0.39'
  gem 'rubocop-checkstyle_formatter'
  gem 'foodcritic', '~> 6.1'
end

group :unit, :integration do
  gem 'rspec_junit_formatter'
  gem 'minitest', '~> 5.0'
  gem 'cheffish', '~> 2.0'
  gem 'chefspec', '~> 5.0'
  gem 'chef', '~> 12.9'
end

group :kitchen_common do
  gem 'berkshelf', '~> 4.0'
  gem 'test-kitchen', git: 'git@github.intuit.com:SBG/test-kitchen.git'
  gem 'kitchen-sync'
  gem 'kitchen-transport-sshtar'
  gem 'kitchen-inspec'
  gem 'inspec', '~> 1.6.0'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant'
end

group :ec2 do
  gem 'kitchen-ec2', git: 'git@github.intuit.com:SBG/kitchen-ec2.git'
end
