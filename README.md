## Sensu-Plugins-beanstalk

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-beanstalk.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-beanstalk)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-beanstalk.svg)](http://badge.fury.io/rb/sensu-plugins-beanstalk)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-beanstalk/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-beanstalk)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-beanstalk/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-beanstalk)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-beanstalk.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-beanstalk)

## Functionality

## Files

 * bin/metrics-beanstalkd
 * bin/check-beanstalk-jobs
 * bin/check-beanstalk-watchers
 * bin/check-beanstalk-watchers-to-buried
 * bin/check-beanstalkd

## Usage

## Installation

Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install sensu-plugins-beanstalk -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-beanstalk`

#### Bundler

Add *sensu-plugins-beanstalk* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-beanstalk' do
  options('--prerelease')
  version '0.0.1'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-beanstalk' do
  options('--prerelease')
  version '0.0.1'
end
```

## Notes
