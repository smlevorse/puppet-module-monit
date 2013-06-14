# == Class: monit::package
#
# This class installs the monit package.  It is expected to be called by the
# monit class.
#
# === Parameters
#
# [*ensure*]    - If the package should be installed or not.
#
# === Examples
#
#  class monit ($ensure) {
#
#  class{'monit::package': ensure => $ensure}
#
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
class monit::package ($ensure) inherits monit::params {
  package { $monit::params::monit_package:
    ensure => $ensure,
  }
}