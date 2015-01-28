# Class: bonita_bpm::root_application
#
# This class manages the ROOT application
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
class bonita_bpm::root_application {

  # deploy webapp
  file { "${bonita_bpm::params::catalina_base}/webapps/ROOT/":
    recurse => true,
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/bonita_bpm/root_application/ROOT',
    require => Package[$bonita_bpm::params::pkg_app_srv]
  }

}
