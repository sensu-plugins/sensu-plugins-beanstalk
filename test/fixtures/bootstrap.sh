#!/bin/bash
#
# Set up a beanstalkd instance for Sensu plugin testing.
#

set -e

apt-get update

source /etc/profile
DATA_DIR=/tmp/kitchen/data
RUBY_HOME=${MY_RUBY_HOME}

# Set the locale
apt-get install -y locales
locale-gen en_US.UTF-8
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"

# Install beanstalkd
apt-get install -y beanstalkd build-essential

# Start beanstalkd
service beanstalkd start

# Build and install GEM to test
cd $DATA_DIR
gem build sensu-plugins-beanstalk.gemspec
gem install sensu-plugins-beanstalk-*.gem
