#!/bin/bash
#
# Set up a super simple web server and make it accept GET and POST requests
# for Sensu plugin testing.
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
apt-get install -y beanstalkd

# Start beanstalkd
beanstalkd -l 0.0.0 -p 11300 &

cd $DATA_DIR
SIGN_GEM=false gem build sensu-plugins-beanstalk.gemspec
gem install sensu-plugins-beanstalk-*.gem
gem install beaneater
