# Class: bonita_bpm::logs_application
#
# This class manages the LOGS application
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
class bonita_bpm::logs_application {

  # deploy webapp
  file { "${bonita_bpm::params::catalina_base}/webapps/logs/":
    recurse => true,
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/bonita_bpm/logs_application/logs',
    require => Package[$bonita_bpm::params::pkg_app_srv]
  }

  # set credentials
  file { "${bonita_bpm::params::catalina_base}/webapps/logs/WEB-INF/users.xml":
    mode    => '0640',
    owner   => root,
    group   => $bonita_bpm::params::app_srv_group,
    content => template('bonita_bpm/logs_application/users.xml.erb'),
    require => File["${bonita_bpm::params::catalina_base}/webapps/logs/"],
    notify  => Service[$bonita_bpm::params::service_name],
  }

}
