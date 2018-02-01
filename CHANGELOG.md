# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed [here](https://github.com/sensu-plugins/community/blob/master/HOW_WE_CHANGELOG.md).

## [Unreleased]

## [2.0.0] - 2018-01-31
### Security
- updated rubocop dependency to `~> 0.51.0` per: https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-8418. (@majormoses)

### Breaking Changes
- removed ruby < 2.1 support to support newer rubocop (@majormoses)

### Changed
- appeased the cops (@majormoses)

### Added
- PR template from skel (@majormoses)

## [1.2.0] - 2017-10-22
### Added
- real tests with serverspec (@anakinj)
- check-beanstalkd, ignore missing queues by default. Behavior controlled by `--alert-on-missing parameter`. (@anakinj)

## [1.1.0] - 2017-08-15
### Added
- Option to get the age of a item in the tubes. add age to the --stats (@derkgort)

## [1.0.0] - 2017-07-14
### Added
- metrics-beanstalkd-tubes, get metrics from individual tubes
- Add testing for Ruby 2.3.0
- Add testing for Ruby 2.4.1

### Breaking Changes
- Remove support for Ruby 1.9.3

## [0.0.4] - 2016-02-18
### Fixed
- cert issue

## [0.0.3] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## [0.0.2] - 2015-06-02
### Fixed
- added binstubs

### Changed
- removed cruft from /lib

## [0.0.1] - 2015-04-30
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-beanstalk/compare/2.0.0...HEAD
[2.0.0]: https://github.com/sensu-plugins/sensu-plugins-beanstalk/compare/1.1.0...2.0.0
[1.2.0]: https://github.com/sensu-plugins/sensu-plugins-beanstalk/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/sensu-plugins/sensu-plugins-beanstalk/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-beanstalk/compare/0.0.4...1.0.0
[0.0.4]: https://github.com/sensu-plugins/sensu-plugins-beanstalk/compare/0.0.3...0.0.4
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-beanstalk/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-beanstalk/compare/0.0.1...0.0.2
