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

context 'when server contains tube with jobs' do
  before do
    # Connect to pool
    beaneater = Beaneater::Pool.new('127.0.0.1:11300')
    # Enqueue jobs to tube
    tube = beaneater.tubes['test-tube']
    tube.clear
    tube.put('{ "data" : "data" }')
  end
  describe command("#{check} -s 127.0.0.1 -p 11300 -t test-tube") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/beanstalkd queues check OK: All queues are healthy/) }
  end
  describe command("#{check} -s 127.0.0.1 -p 11300 -t missing-tube -a warning") do
    its(:exit_status) { should eq 1 }
    its(:stdout) { should match(/Tube missing-tube is missing/) }
  end
  describe command("#{check} -s 127.0.0.1 -p 11300 -t missing-tube --alert-on-missing critical") do
    its(:exit_status) { should eq 2 }
    its(:stdout) { should match(/Tube missing-tube is missing/) }
  end
end
