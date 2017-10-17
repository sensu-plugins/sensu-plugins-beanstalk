
require 'codeclimate-test-reporter'
require 'simplecov'

SimpleCov.start do
  add_filter 'test/'
end

class PluginStub
  def run; end

  def ok(*); end

  def warning(*); end

  def critical(*); end

  def unknown(*); end
end

RSpec.configure do |c|
  c.before(:suite) do
    Sensu::Plugin::CLI.class_variable_set(:@@autorun, PluginStub)
  end
end

CodeClimate::TestReporter.start
