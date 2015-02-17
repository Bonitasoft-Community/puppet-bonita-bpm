# Class: bonita_bpm
#
# This is the main class to manage bonita_bpm
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
class bonita_bpm (
  # mandatory parameters
  $version                           = $::bonita_bpm_version,
  $edition                           = $::bonita_bpm_edition,
  $archive                           = $::bonita_bpm_archive,
  # the license is not mandatory if edition is equal to community
  $license                           = $::bonita_bpm_license,
  # database parameters used for bonitaDS and bonitaSequenceManagerDS
  $db_vendor                         = $::bonita_bpm_db_vendor,
  $db_name                           = $::bonita_bpm_db_name,
  $db_user                           = $::bonita_bpm_db_user,
  $db_pass                           = $::bonita_bpm_db_pass,
  $db_host                           = $::bonita_bpm_db_host,
  $db_port                           = $::bonita_bpm_db_port,
  $bonitaDS_minIdle                  = $::bonita_bpm_bonitaDS_minIdle,
  $bonitaDS_maxActive                = $::bonita_bpm_bonitaDS_maxActive,
  $bonitaSequenceManagerDS_minIdle   = $::bonita_bpm_bonitaSequenceManagerDS_minIdle,
  $bonitaSequenceManagerDS_maxActive = $::bonita_bpm_bonitaSequenceManagerDS_maxActive,
  # optional datasource for business database
  $businessDS_db_vendor              = $::bonita_bpm_businessDS_db_vendor,
  $businessDS_name                   = $::bonita_bpm_businessDS_name,
  $businessDS_user                   = $::bonita_bpm_businessDS_user,
  $businessDS_pass                   = $::bonita_bpm_businessDS_pass,
  $businessDS_host                   = $::bonita_bpm_businessDS_host,
  $businessDS_port                   = $::bonita_bpm_businessDS_port,
  $businessDS_minIdle                = $::bonita_bpm_businessDS_minIdle,
  $businessDS_maxActive              = $::bonita_bpm_businessDS_maxActive,
  # platform credentials
  $platform_admin_user               = $::bonita_bpm_platform_admin_user,
  $platform_admin_pass               = $::bonita_bpm_platform_admin_pass,
  # jvm and tomcat tuning
  $java_opts                         = $::bonita_bpm_java_opts,
  $jmx_pass                          = $::bonita_bpm_jmx_pass,
  $maxThreads                        = $::bonita_bpm_maxThreads,
  $server_info                       = $::bonita_bpm_server_info,
  # bonita workers configuration
  $corePoolSize                      = $::bonita_bpm_corePoolSize,
  $maximumPoolSize                   = $::bonita_bpm_maximumPoolSize,
  # bonita connectors configuration
  $connectorTimeout                  = $::bonita_bpm_connectorTimeout,
  # quartz configuration
  $quartz_threadCount                = $::bonita_bpm_quartz_threadCount,
  # HTTP API
  $http_api                          = $::bonita_bpm_http_api,
  # tenants configuration
  $tenants                           = $::bonita_bpm_tenants,
  # bonita home path
  $home_parent_dir                   = $::bonita_bpm_home_parent_dir,
) {

  # check and define default parameters
  include bonita_bpm::params
  # install the App Server
  include bonita_bpm::install_app_server
  # deploy Bonita BPM
  include bonita_bpm::deploy_bonita_bpm
  # if available, configure jmx
  if $jmx_pass != undef {
    include bonita_bpm::jmx
  }
}
