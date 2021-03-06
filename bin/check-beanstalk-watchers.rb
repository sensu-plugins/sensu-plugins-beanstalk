#! /usr/bin/env ruby
#
# check-beanstalk-watchers
#
# DESCRIPTION:
#   #YELLOW
#
# OUTPUT:
#   plain-text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: beanstalk-client
#   gem: sensu-plugin
#
# USAGE:
#   #YELLOW
#
# NOTES:
#
# LICENSE:
#   Copyright S. Zachariah Sprackett <zac@sprackett.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'beanstalk-client'

#
# Check Beanstalk Watchers
#
class CheckBeanstalkWatchers < Sensu::Plugin::Check::CLI
  option :host,
         short: '-H HOST',
         default: 'localhost'
  option :port,
         short: '-p PORT',
         default: '11300'
  option :tube,
         short: '-t TUBE'
  option :crit,
         short: '-c CRIT_THRESHOLD',
         proc: proc(&:to_i),
         default: false
  option :warn,
         short: '-w WARN_THRESHOLD',
         proc: proc(&:to_i),
         default: false

  def run
    unknown 'Tube was not set' unless config[:tube]
    begin
      beanstalk = Beanstalk::Connection.new(
        "#{config[:host]}:#{config[:port]}"
      )
    rescue StandardError => e
      critical "Failed to connect: (#{e})"
    end

    begin
      stats = beanstalk.stats_tube(config[:tube])
      watchers = stats['current-watching'].to_i
    rescue Beanstalk::NotFoundError
      warning "Tube #{config[:tube]} not found"
    end
    watchers ||= 0
    if config[:crit] && watchers < config[:crit]
      critical "Required at least #{config[:crit]} watchers but have #{watchers}"
    elsif config[:warn] && watchers < config[:warn]
      warning "Required at least #{config[:warn]} watchers but have #{watchers}"
    else
      ok "#{watchers} watchers found."
    end
  end
end
