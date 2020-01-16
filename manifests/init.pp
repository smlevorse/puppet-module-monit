# == Class: monit
#
# This module controls Monit
#
# === Parameters
#
# [*ensure*]    - If you want the service running or not
# [*admin*]     - Admin email address
# [*interval*]  - How frequently the check runs
# [*delay*]     - How long to wait before actually performing any action
# [*logfile*]   - What file for monit use for logging
# [*mailserver] - Which mailserver to use
# === Examples
#
#  class { 'monit':
#    admin    => 'me@mydomain.local',
#    interval => 30,
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
class monit (
  $ensure                  = present,
  $admin                   = undef,
  $interval                = 60,
  $delay                   = $interval * 2,
  $logfile                 = $monit::params::logfile,
  $mailserver              = 'localhost',
  $httpd_port              = 2812,
  $allow_remote            = false,
  $monit_user              = undef,
  $monit_password          = undef,
  $package_version         = undef,
  $use_ssl                 = undef,
  $ssl_or_tls              = undef,
  $ssl_version             = undef,
  $ssl_verify              = undef,
  $ssl_selfsign_allow      = undef,
  $ssl_ciphers             = undef,
  $ssl_pemfile             = undef,
  $ssl_cert_file_path      = undef,
  $ssl_cert_directory_path = undef,
) inherits monit::params {

  $conf_include = "${monit::params::conf_dir}/*"

  if ($ensure == 'present') {
    $run_service = true
    $service_state = 'running'
    $package_ensure = pick($package_version, $ensure)
  } else {
    $run_service = false
    $service_state = 'stopped'
    $package_ensure = $ensure
  }

  package { $monit::params::monit_package:
    ensure => $package_ensure,
  }

  # Template uses: $admin, $conf_include, $interval, $logfile, $httpd_port
  file { $monit::params::conf_file:
    ensure  => $ensure,
    content => template('monit/monitrc.erb'),
    mode    => '0600',
    require => Package[$monit::params::monit_package],
    notify  => Service[$monit::params::monit_service],
  }

  file { $monit::params::conf_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Not all platforms need this
  if ($monit::params::default_conf) {
   if ($monit::params::default_conf_tpl) {
    file { $monit::params::default_conf:
      ensure  => $ensure,
      content => template("monit/$monit::params::default_conf_tpl"),
      require => Package[$monit::params::monit_package],
    }

   }
   else { fail("You need to provide config template")}

  }

  # Template uses: $logfile
  file { $monit::params::logrotate_script:
    ensure  => $ensure,
    content => template("monit/${monit::params::logrotate_source}"),
    require => Package[$monit::params::monit_package],
  }

  if $::osfamily == 'redhat' {
    file { '/var/lib/monit':
	    ensure  => directory,
	    owner   => 'root',
	    group   => 'root',
	    mode    => '0755',
	    before  => Service[$monit::params::monit_service]
	  }
  }

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
