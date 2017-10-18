# frozen_string_literal: true

require_relative 'shared_examples'
require 'beaneater'

gem_path   = '/usr/local/bin'
check_name = 'check-beanstalkd.rb'
check      = "#{gem_path}/#{check_name}"

describe 'ruby environment' do
  it_behaves_like 'ruby checks', check
end

describe command("#{check} -s i.do.not.exist.local") do
  its(:exit_status) { should eq 1 }
  its(:stdout) { should match(/beanstalkd queues check WARNING: could not connect to beanstalkd/) }
end

context 'stuff exists' do
  before do
    # Connect to pool
    beaneater = Beaneater::Pool.new('127.0.0.1:11300')
    # Enqueue jobs to tube
    tube = beaneater.tubes["test-tube"]
    tube.clear
    tube.put('{ "data" : "data" }')
  end
  describe command("#{check} -s 127.0.0.1 -p 11300 -t test-tube") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/beanstalkd queues check WARNING: could not connect to beanstalkd/) }
  end
end
