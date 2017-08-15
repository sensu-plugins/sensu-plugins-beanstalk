#! /usr/bin/env ruby
#
# beanstalkd-metrics-tubes
#
# DESCRIPTION:
#  This plugin checks the beanstalkd tube-stats, using the beaneater gem
#
# OUTPUT:
#   metric-data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: beaneater
#   gem: sensu-plugin
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Joakim Antman <antmanj@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'beaneater'

#
# Collects beanstalk tube metrics
#
class BeanstalkdMetrics < Sensu::Plugin::Metric::CLI::Graphite
  option :host,
         description: 'beanstalkd server',
         short:       '-h HOST',
         long:        '--host HOST',
         default:     'localhost'

  option :port,
         description: 'beanstalkd server port',
         short:       '-p PORT',
         long:        '--port PORT',
         proc:        proc(&:to_i),
         default:     11_300

  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.beanstalkd"

  option :tubes,
         description: 'Comma separate list of tubes to collect metrics from',
         short: '-t TUBES',
         long: '--tubes TUBES',
         default: '*'

  option :stats,
         description: 'Comma separate list of tube-stats to collect',
         long: '--stats STATS',
         default: '*'

  def run
    tubes.each do |tube|
      output_stats(tube)
    end
    ok
  end

  private

  INGORED_KEYS = ['name'].freeze

  def tube_age(tube)
    job = tube.peek(:ready)
    if !job.nil?
      job.stats.age
    else
      0
    end
  end

  def output_stats(tube)
    stats = tube.stats
    stats.keys.sort.each do |key|
      next unless matches_filter?(:stats, key)
      next if INGORED_KEYS.include?(key)
      output "#{config[:scheme]}.#{tube.name}.#{key}", stats[key]
    end
    output "#{config[:scheme]}.#{tube.name}.age", tube_age(tube) if matches_filter?(:stats, 'age')
  end

  def tubes
    connection.tubes.all.select { |tube| matches_filter?(:tubes, tube.name) }
  end

  def matches_filter?(key, value)
    @tube_filters ||= {}
    unless @tube_filters.key?(key)
      @tube_filters[key] = Array(config[key].split(',').map(&:strip))
    end
    @tube_filters[key].any? { |filter| File.fnmatch?(filter, value.to_s) }
  end

  def connection
    @conn ||= Beaneater::Pool.new(["#{config[:host]}:#{config[:port]}"])
  rescue => e
    warning "could not connect to beanstalkd: #{e}"
  end
end
