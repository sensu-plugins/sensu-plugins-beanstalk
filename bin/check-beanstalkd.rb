#! /usr/bin/env ruby
#
# check-beanstalkd
#
# DESCRIPTION:
#  Check beanstalkd queues
#
# OUTPUT:
#   plain-text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: beaneater
#   gem: sensu-plugin
#
# USAGE:
#   #YELLOW
#
# NOTES:
#
# LICENSE:
#   Copyright 2014 99designs, Inc <devops@99designs.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'json'
require 'beaneater'

#
# Checks the queue levels
#
class BeanstalkdQueuesStatus < Sensu::Plugin::Check::CLI
  check_name 'beanstalkd queues check'

  option :tube,
         short:       '-t name',
         long:        '--tube name',
         description: 'Name of the tube to check',
         default:     'default'

  option :server,
         description: 'beanstalkd server',
         short:       '-s SERVER',
         long:        '--server SERVER',
         default:     'localhost'

  option :port,
         description: 'beanstalkd server port',
         short:       '-p PORT',
         long:        '--port PORT',
         default:     '11300'

  option :alert_on_missing,
         description: 'alert type when tube is missing',
         short:       '-a TYPE',
         long:        '--alert-on-missing TYPE',
         proc:        proc { |value| value.to_sym },
         in:          [:critical, :warning, :ignore],
         default:     :ignore

  option :ready,
         description: 'ready tasks WARNING/CRITICAL thresholds',
         short:       '-r W,C',
         long:        '--ready-tasks W,C',
         proc:        proc { |a| a.split(',', 2).map(&:to_i) },
         default:     [6000, 8000]

  option :urgent,
         description: 'urgent tasks WARNING/CRITICAL thresholds',
         short:       '-u W,C',
         long:        '--urgent-tasks W,C',
         proc:        proc { |a| a.split(',', 2).map(&:to_i) },
         default:     [2000, 3000]

  option :buried,
         description: 'buried tasks WARNING/CRITICAL thresholds',
         short:       '-b W,C',
         long:        '--buried-tasks W,C',
         proc:        proc { |a| a.split(',', 2).map(&:to_i) },
         default:     [30, 60]

  def acquire_beanstalkd_connection
    begin
      conn = Beaneater::Pool.new(["#{config[:server]}:#{config[:port]}"])
    rescue
      warning 'could not connect to beanstalkd'
    end
    conn
  end

  def run
    warns, crits, msg = check_queues(tube_stats)
    message 'All queues are healthy'

    unless crits.empty?
      message msg
      critical
    end

    unless warns.empty?
      message msg
      warning
    end

    ok
  end

  JOB_STATES = [:ready, :urgent, :buried].freeze

  def check_queues(stats)
    msg = []
    crits = {}
    warns = {}

    JOB_STATES.each do |job_state|
      jobs = stats.send("current_jobs_#{job_state}".to_sym)

      if jobs > config[job_state][1]
        crits[job_state] = jobs
        msg << job_state.to_s + " queue has #{jobs} items"
        next
      end

      if jobs > config[job_state][0]
        warns[job_state] = jobs
        msg << job_state.to_s + " queue has #{jobs} items"
      end
    end

    [warns, crits, msg]
  end

  def tube_stats
    acquire_beanstalkd_connection.tubes[config[:tube].to_s].stats
  rescue Beaneater::NotFoundError
    case config[:alert_on_missing]
    when :warning, :critical
      send(config[:alert_on_missing], "Tube #{config[:tube]} is missing")
    else
      empty_queue_stats
    end
  end

  def empty_queue_stats
    stats = OpenStruct.new

    JOB_STATES.each do |job_state|
      stats.send("current_jobs_#{job_state}=", 0)
    end

    stats
  end
end
