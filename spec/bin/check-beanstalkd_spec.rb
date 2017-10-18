require_relative '../spec_helper'
require_relative '../../bin/check-beanstalkd'

describe BeanstalkdQueuesStatus do
  let(:beaneater_mock) { instance_double(Beaneater::Pool) }
  let(:tubes_mock)     { instance_double(Beaneater::Tubes) }
  let(:tube_mock)      { instance_double(Beaneater::Tube) }
  let(:stats_mock)     { instance_double(Beaneater::Stats) }

  def mock_beanstalkd
    expect(Beaneater::Pool).to receive(:new).and_return(beaneater_mock)
    expect(beaneater_mock).to receive(:tubes).and_return(tubes_mock)
  end

  def mock_tube(tube_name, stats_mock)
    expect(tubes_mock).to receive(:[]).with(tube_name).and_return(tube_mock)
    expect(tube_mock).to receive(:stats).and_return(OpenStruct.new(stats_mock))
  end

  def mock_result_methods(instance)
    allow(instance).to receive(:critical)
    allow(instance).to receive(:warning)
    allow(instance).to receive(:ok)
  end

  it 'calls warning when no beanstalk connection can be opened' do
    check_instance = described_class.new
    expect(Beaneater::Pool).to receive(:new).and_raise('Random error')
    expect(check_instance).to receive(:warning).and_raise('FAIL')

    expect { check_instance.run }.to raise_error 'FAIL'
  end

  it 'is ok if connection can be established and tube stats are under thresholds' do
    mock_beanstalkd
    mock_tube('tube', current_jobs_ready: 400,
                      current_jobs_urgent: 0,
                      current_jobs_buried: 0)

    check_instance = described_class.new(['-t', 'tube'])
    expect(check_instance).to receive(:ok)
    check_instance.run
  end

  it 'calls critical if tube stats are over thresholds' do
    mock_beanstalkd
    mock_tube('default', current_jobs_ready: 5,
                         current_jobs_urgent: 30,
                         current_jobs_buried: 30)

    check_instance = described_class.new(['-u', '10,20', '-r', '10,20', '-b', '10,20'])

    mock_result_methods(check_instance)
    expect(check_instance).to receive(:critical)
    check_instance.run

    # This is probably a bug, How do we want to present the messages?
    expect(check_instance.instance_variable_get(:@message)).to eq(['urgent queue has 30 items', 'buried queue has 30 items'])
  end

  it 'calls warning if tube stats are over thresholds' do
    mock_beanstalkd
    mock_tube('default', current_jobs_ready: 5,
                         current_jobs_urgent: 11,
                         current_jobs_buried: 10)

    check_instance = described_class.new(['-u', '10,20', '-r', '10,20', '-b', '10,20'])

    mock_result_methods(check_instance)
    expect(check_instance).not_to receive(:critical)
    expect(check_instance).to receive(:warning)
    check_instance.run

    # This is probably a bug, How do we want to present the messages?
    expect(check_instance.instance_variable_get(:@message)).to eq(['urgent queue has 11 items'])
  end
end
