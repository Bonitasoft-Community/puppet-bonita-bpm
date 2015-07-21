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
  # optional datasource for custom needs
  $CustomDS_db_vendor                = $::bonita_bpm_CustomDS_db_vendor,
  $CustomDS_name                     = $::bonita_bpm_CustomDS_name,
  $CustomDS_user                     = $::bonita_bpm_CustomDS_user,
  $CustomDS_pass                     = $::bonita_bpm_CustomDS_pass,
  $CustomDS_host                     = $::bonita_bpm_CustomDS_host,
  $CustomDS_port                     = $::bonita_bpm_CustomDS_port,
  $CustomDS_minIdle                  = $::bonita_bpm_CustomDS_minIdle,
  $CustomDS_maxActive                = $::bonita_bpm_CustomDS_maxActive,
  # platform credentials
  $platform_admin_user               = $::bonita_bpm_platform_admin_user,
  $platform_admin_pass               = $::bonita_bpm_platform_admin_pass,
  # jvm and tomcat tuning
  $java_opts                         = $::bonita_bpm_java_opts,
  $jmx_pass                          = $::bonita_bpm_jmx_pass,
  $maxThreads                        = $::bonita_bpm_maxThreads,
  $server_info                       = $::bonita_bpm_server_info,
  $RemoteIpValve_internalProxies     = $::bonita_bpm_RemoteIpValve_internalProxies,
  $AccessLogValve_pattern            = $::bonita_bpm_AccessLogValve_pattern,
  # bonita workers configuration
  $corePoolSize                      = $::bonita_bpm_corePoolSize,
  $maximumPoolSize                   = $::bonita_bpm_maximumPoolSize,
  # bonita connectors configuration
  $connectorTimeout                  = $::bonita_bpm_connectorTimeout,
  # quartz configuration
  $quartz_threadCount                = $::bonita_bpm_quartz_threadCount,
  # HTTP API
  $http_api                          = $::bonita_bpm_http_api,
  # security checks on portal servlets
  $portal_servlet_security_checks    = $::bonita_bpm_portal_servlet_security_checks,
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
