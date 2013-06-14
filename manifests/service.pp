# == Class: monit::service
#
# This class handles the monit service.  It is expected to be called by the
# monit class.
#
# === Parameters
#
# [*run_service*]   - If the package should be installed or not.
# [*service_state*] - If the package should be installed or not.
#
# === Examples
#
#  class monit ($ensure) {
#
#  class {'monit::service':
#    run_service   => $run_service,
#    service_state => $service_state
#  }
#
# === Authors
#
# Eivind Uggedal <eivind@uggedal.com>
# Jonathan Thurman <jthurman@newrelic.com>
#
# === Copyright
#
# Copyright 2011 Eivind Uggedal <eivind@uggedal.com>
#
class monit::service ($run_service, $service_state) inherits monit::params {
  service { $monit::params::monit_service:
    ensure     => $service_state,
    enable     => $run_service,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => File[$monit::params::conf_file],
    require    => [
      File[$monit::params::conf_file],
      File[$monit::params::logrotate_script]
    ],
  }
}