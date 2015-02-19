# Class: bonita_bpm::deploy_bonita_bpm
#
# This class deploys Bonita BPM and configures the App Server accordingly
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
class bonita_bpm::deploy_bonita_bpm {
  # define JVM properties
  file { "${bonita_bpm::params::setenv_path}/${bonita_bpm::params::setenv_file}":
    path    => "${bonita_bpm::params::setenv_path}/${bonita_bpm::params::setenv_file}",
    mode    => '0755',
    owner   => root,
    group   => root,
    content => template("bonita_bpm/${bonita_bpm::params::setenv_file}.erb"),
    require => Package[$bonita_bpm::params::pkg_app_srv],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  # retrive Bonita BPM archive
  file { "/var/tmp/${bonita_bpm::archive}":
    name    => "/var/tmp/${bonita_bpm::archive}",
    mode    => '0644',
    owner   => root,
    group   => root,
    source  => "puppet:///modules/bonita_bpm/archives/${bonita_bpm::archive}",
    require => Package[$bonita_bpm::params::pkg_app_srv]
  }

  # create temporary directory (preserved between reboots)
  file { ['/var/tmp/BOS']:
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root
  }

  file { $bonita_bpm::params::home_parent_dir:
    ensure  => directory,
    mode    => '0755',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    require => Package[$bonita_bpm::params::pkg_app_srv],
  }

  file { "${bonita_bpm::params::catalina_base}/lib":
    ensure  => directory,
    mode    => '0755',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    require => Package[$bonita_bpm::params::pkg_app_srv],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  file { ["${bonita_bpm::params::home}/server/tenants/"]:
    ensure  => directory,
    mode    => '0755',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    require => Exec['copy_bonita_conf'],
  }

  file { ["${bonita_bpm::params::home}/client/tenants/"]:
    ensure  => directory,
    mode    => '0755',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    require => Exec['copy_bonita_conf'],
  }

  # Apply configuration at platform level
  # apply bonita-platform template to set platform credentials
  file { 'bonita_platform_conf':
    path    => "${bonita_bpm::params::home}/server/platform/conf/bonita-platform.properties",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/bonita-platform.properties.erb"),
    require => Exec['copy_bonita_conf'],
    notify  => Service[$bonita_bpm::params::service_name],
  }
  # apply platform-tenant-config to set tenant credentials
  file { 'platform_tenant_config':
    path    => "${bonita_bpm::params::home}/client/platform/conf/platform-tenant-config.properties",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/platform-tenant-config.properties.erb"),
    require => Exec['copy_bonita_conf'],
    notify  => Service[$bonita_bpm::params::service_name],
  }
  file { 'scheduler_conf':
    path    => "${bonita_bpm::params::home}/server/platform/conf/services/cfg-bonita-scheduler-quartz.xml",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/cfg-bonita-scheduler-quartz.xml.erb"),
    require => Exec['copy_bonita_conf'],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  # Apply configuration at tenant level
  bonita_bpm::configure_tenants{ $bonita_bpm::params::tenants:}
  # Apply also modifications into tenant-template directory at platform level to have the right parameters at tenant creation
  # Activate static permissions checks (to ensure apply this even after a migration)
  file { 'security-config.properties':
    path    => "${bonita_bpm::params::home}/client/platform/tenant-template/conf/security-config.properties",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    source  => "puppet:///modules/bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/security-config.properties",
    require => Exec['copy_bonita_conf'],
    notify  => Service[$bonita_bpm::params::service_name],
  }
  # Activate dynamic permissions checks
  file { 'dynamic-permissions-checks.properties':
    path    => "${bonita_bpm::params::home}/client/platform/tenant-template/conf/dynamic-permissions-checks.properties",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    source  => "puppet:///modules/bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/dynamic-permissions-checks.properties",
    require => Exec['copy_bonita_conf'],
    notify  => Service[$bonita_bpm::params::service_name],
  }
  # apply workers template at tenant level since 6.3.0
  file { 'workers_conf':
    path    => "${bonita_bpm::params::home}/server/platform/tenant-template/conf/services/cfg-bonita-work-factory.xml",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/cfg-bonita-work-factory.xml.erb"),
    require => Exec['copy_bonita_conf'],
    notify  => Service[$bonita_bpm::params::service_name],
  }
  # apply connectors template if available (performance edition and version >= 6.1)
  if $bonita_bpm::params::connectors_tpl != undef {
    file { 'connectors_conf':
      path    => "${bonita_bpm::params::home}/server/platform/tenant-template/conf/services/${bonita_bpm::params::connectors_file}",
      mode    => '0644',
      owner   => $bonita_bpm::params::app_srv_user,
      group   => $bonita_bpm::params::app_srv_group,
      content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/${bonita_bpm::params::connectors_tpl}"),
      require => Exec['copy_bonita_conf'],
      notify  => Service[$bonita_bpm::params::service_name],
    }
  }
  # apply bonita-server template to set tenant credentials
  $tenant_admin_user = $bonita_bpm::params::tenants[0]['user']
  $tenant_admin_pass = $bonita_bpm::params::tenants[0]['pass']
  # this handles also datamanagement conf if available (performance edition and version >= 6.3)
  if $bonita_bpm::edition == 'performance' {
    $businessdata_ds_jndi           = $bonita_bpm::params::tenants[0]['business_data']['ds']['name']
    $businessdata_dsxa_jndi         = $bonita_bpm::params::tenants[0]['business_data']['dsxa']['name']
    $businessdata_hibernate_dialect = $bonita_bpm::params::tenants[0]['business_data']['ds_common']['hibernate_dialect']
  }
  file { 'bonita_server_conf':
    path    => "${bonita_bpm::params::home}/server/platform/tenant-template/conf/bonita-server.properties",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/bonita-server.properties.erb"),
    require => Exec['copy_bonita_conf'],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  file { 'bitronix-config.properties':
    path    => "${bonita_bpm::params::catalina_base}/conf/bitronix-config.properties",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    content => template('bonita_bpm/bitronix/bitronix-config.properties.erb'),
    require => Package[$bonita_bpm::params::pkg_app_srv],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  file { 'bitronix-resources.properties':
    path    => "${bonita_bpm::params::catalina_base}/conf/bitronix-resources.properties",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    content => template('bonita_bpm/bitronix/bitronix-resources.properties.erb'),
    require => Package[$bonita_bpm::params::pkg_app_srv],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  file { 'server.xml':
    path    => "${bonita_bpm::params::app_srv_conf}/server.xml",
    mode    => '0644',
    owner   => root,
    group   => $bonita_bpm::params::app_srv_group,
    content => template("bonita_bpm/${::operatingsystem}/${::operatingsystemrelease}/${bonita_bpm::params::pkg_app_srv}/server.xml.erb"),
    require => [File['bitronix-config.properties', 'bitronix-resources.properties'],Exec['copy_libs']],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  file { 'context.xml':
    path    => "${bonita_bpm::params::app_srv_conf}/context.xml",
    mode    => '0644',
    owner   => root,
    group   => $bonita_bpm::params::app_srv_group,
    content => template('bonita_bpm/context.xml.erb'),
    require => Package[$bonita_bpm::params::pkg_app_srv],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  file { 'catalina.properties':
    path    => "${bonita_bpm::params::app_srv_conf}/catalina.properties",
    mode    => '0644',
    owner   => root,
    group   => $bonita_bpm::params::app_srv_group,
    source  => "puppet:///modules/bonita_bpm/${::operatingsystem}/${::operatingsystemrelease}/${bonita_bpm::params::pkg_app_srv}/catalina.properties",
    require => Package[$bonita_bpm::params::pkg_app_srv],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  file { 'logging.properties':
    path    => "${bonita_bpm::params::app_srv_conf}/logging.properties",
    mode    => '0644',
    owner   => root,
    group   => $bonita_bpm::params::app_srv_group,
    content => template("bonita_bpm/${::operatingsystem}/${::operatingsystemrelease}/${bonita_bpm::params::pkg_app_srv}/logging.properties.erb"),
    require => Package[$bonita_bpm::params::pkg_app_srv],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  file { 'bonita.xml':
    path    => "${bonita_bpm::params::app_srv_conf}/Catalina/localhost/bonita.xml",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    content => template('bonita_bpm/bonita.xml.erb'),
    require => Exec['copy_bonita_conf'],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  # Activate/Deactivate HTTP API
  file { ['/var/tmp/WEB-INF']:
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root
  }
  file { 'web.xml':
    path    => '/var/tmp/WEB-INF/web.xml',
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/web.xml.erb"),
    require => File['/var/tmp/WEB-INF'],
  }

  exec {
    'untar_bos':
      cwd     => '/var/tmp/BOS',
      command => "/bin/tar -xvzf /var/tmp/${bonita_bpm::archive}",
      creates => '/var/tmp/BOS/bonita/',
      require => File['/var/tmp/BOS',"/var/tmp/${bonita_bpm::archive}"];

    #Copy *.jar
    'copy_libs':
      command => "cp -a /var/tmp/BOS/lib/bonita/ ${bonita_bpm::params::catalina_base}/lib/bonita/",
      creates => "${bonita_bpm::params::catalina_base}/lib/bonita/",
      require => [Exec['untar_bos'],Package[$bonita_bpm::params::service_name]];

    #BONITA_HOME folder, contains all Bonita BPM configuration files
    'copy_bonita_conf':
      command => "cp -ar /var/tmp/BOS/bonita ${bonita_bpm::params::home}",
      creates => $bonita_bpm::params::home,
      require => [Exec['untar_bos'],Package[$bonita_bpm::params::service_name]];

    #Ensure that BONITA_HOME has proper owner even after a restore
    'apply_ownership':
      command => "chown -R ${bonita_bpm::params::app_srv_user}:${bonita_bpm::params::app_srv_group} ${bonita_bpm::params::home}",
      require => Exec['copy_bonita_conf'];

    #Update bonita.war with proper web.xml
    'update_web_xml_into_war':
      command     => 'zip /var/tmp/BOS/webapps/bonita.war WEB-INF/web.xml',
      cwd         => '/var/tmp/',
      require     => [Exec['untar_bos'], File['web.xml']],
      subscribe   => File['web.xml'],
      refreshonly => true,
      notify      => Exec['copy_war'];

    #Deploy war including engine & portal
    'copy_war':
      command => "rm -rf ${bonita_bpm::params::catalina_base}/webapps/bonita && cp -a /var/tmp/BOS/webapps/bonita.war ${bonita_bpm::params::catalina_base}/webapps/bonita.war",
      unless  => "diff /var/tmp/BOS/webapps/bonita.war ${bonita_bpm::params::catalina_base}/webapps/bonita.war",
      require => [Exec['copy_bonita_conf','copy_libs'],Package[$bonita_bpm::params::service_name]],
      notify  => Service[$bonita_bpm::params::service_name],
  }

  case $bonita_bpm::params::db_vendor {
    'mysql', 'postgres': {
      # install the database driver
      package { $bonita_bpm::params::pkg_driver : ensure => installed }
      # link driver and app server
      file { $bonita_bpm::params::driver_path:
        ensure  => link,
        target  => $bonita_bpm::params::driver_target,
        require => Package[$bonita_bpm::params::pkg_app_srv,$bonita_bpm::params::pkg_driver],
        notify  => Service[$bonita_bpm::params::service_name],
      }
    }
    default: {}
  }
  # If Business database driver is not the same as Bonita DB driver install it
  if $bonita_bpm::params::db_vendor != $bonita_bpm::params::businessDS_db_vendor {
    case $bonita_bpm::params::businessDS_db_vendor {
      'mysql', 'postgres': {
        # install the database driver
        package { $bonita_bpm::params::businessDS_pkg_driver : ensure => installed }
        # link driver and app server
        file { $bonita_bpm::params::businessDS_driver_path:
          ensure  => link,
          target  => $bonita_bpm::params::businessDS_driver_target,
          require => Package[$bonita_bpm::params::pkg_app_srv,$bonita_bpm::params::businessDS_pkg_driver],
          notify  => Service[$bonita_bpm::params::service_name],
        }
      }
      default: {}
    }
  }

  case $bonita_bpm::edition {
    'teamwork', 'efficiency', 'performance': {
      file { 'license':
        path    => "${bonita_bpm::params::home}/server/licenses/${bonita_bpm::license}",
        mode    => '0640',
        owner   => $bonita_bpm::params::app_srv_user,
        group   => $bonita_bpm::params::app_srv_group,
        source  => "puppet:///modules/bonita_bpm/licenses/${bonita_bpm::license}",
        require => Exec['copy_bonita_conf'],
      }
    }
    default: {}
  }

}
