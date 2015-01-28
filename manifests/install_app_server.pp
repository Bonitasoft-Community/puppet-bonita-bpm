# Class: bonita_bpm::install_app_server
#
# This class installs the App Server
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
class bonita_bpm::install_app_server {

  package { $bonita_bpm::params::pkg_list: ensure => installed }

  service { $bonita_bpm::params::service_name:
    ensure    => running,
    enable    => true,
    require   => Package[$bonita_bpm::params::pkg_app_srv],
  }

}
