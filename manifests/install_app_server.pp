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

  if $bonita_bpm::server_info != undef {
    # create directory tree in order to overwrite Server Info
    file { ["${bonita_bpm::params::catalina_base}/lib/org/","${bonita_bpm::params::catalina_base}/lib/org/apache/","${bonita_bpm::params::catalina_base}/lib/org/apache/catalina/","${bonita_bpm::params::catalina_base}/lib/org/apache/catalina/util/"]:
      ensure  => directory,
      owner   => root,
      group   => root,
      require => Package[$bonita_bpm::params::pkg_app_srv]
    }
    file { "${bonita_bpm::params::catalina_base}/lib/org/apache/catalina/util/ServerInfo.properties":
      content => "server.info=${bonita_bpm::server_info}",
      mode    => '0644',
      owner   => root,
      group   => root,
      require => File["${bonita_bpm::params::catalina_base}/lib/org/apache/catalina/util/"],
      notify  => Service[$bonita_bpm::params::service_name],
    }
  } else {
    file { "${bonita_bpm::params::catalina_base}/lib/org/":
      ensure  => absent,
      recurse => true,
      force   => true,
      require => Package[$bonita_bpm::params::pkg_app_srv],
      notify  => Service[$bonita_bpm::params::service_name],
    }
  }
}
