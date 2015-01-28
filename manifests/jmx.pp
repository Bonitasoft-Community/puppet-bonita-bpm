# Class: bonita_bpm::jmx
#
# This class manages jmx configuration
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class bonita_bpm::jmx {

  file { "${bonita_bpm::params::app_srv_conf}/jmx":
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => $bonita_bpm::params::app_srv_group,
    require => Package[$bonita_bpm::params::pkg_app_srv]
  }
  #authentication config
  file { 'jmxremote.password':
    path    => "${bonita_bpm::params::app_srv_conf}/jmx/jmxremote.password",
    mode    => '0600',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    content => template('bonita_bpm/jmx/jmxremote.password.erb'),
    require => File["${bonita_bpm::params::app_srv_conf}/jmx"]
  }
  #authorization config
  file { 'jmxremote.access':
    path    => "${bonita_bpm::params::app_srv_conf}/jmx/jmxremote.access",
    mode    => '0600',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    content => template('bonita_bpm/jmx/jmxremote.access.erb'),
    require => File['jmxremote.password']
  }

}
