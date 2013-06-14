# == Class: monit::service
#
# This class handles the monit service.  It is expected to be called by the
# monit class.
#
# === Parameters
#
# [*run_service*]   - Enable or disable service.
# [*service_state*] - State of running service.
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
  }
}
