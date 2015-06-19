# A defined type to configure tenants
define bonita_bpm::configure_tenants {
  $tenant_id=$name['id']
  if $bonita_bpm::params::major_version == '6' {
    file { ["${bonita_bpm::params::home}/server/tenants/${tenant_id}", "${bonita_bpm::params::home}/server/tenants/${tenant_id}/conf", "${bonita_bpm::params::home}/server/tenants/${tenant_id}/conf/services/"]:
      ensure  => directory,
      mode    => '0755',
      owner   => $bonita_bpm::params::app_srv_user,
      group   => $bonita_bpm::params::app_srv_group,
      require => File["${bonita_bpm::params::home}/server/tenants/"],
    }
  } else {
    file { "${bonita_bpm::params::home}/engine-server/conf/tenants/${tenant_id}":
      ensure  => directory,
      mode    => '0755',
      owner   => $bonita_bpm::params::app_srv_user,
      group   => $bonita_bpm::params::app_srv_group,
      require => File["${bonita_bpm::params::home}/engine-server/tenants/"],
    }
  }

  file { ["${bonita_bpm::params::home}/client/tenants/${tenant_id}", "${bonita_bpm::params::home}/client/tenants/${tenant_id}/conf"]:
    ensure  => directory,
    mode    => '0755',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    require => File["${bonita_bpm::params::home}/client/tenants/"],
  }
  # Activate static permissions checks (to ensure apply this even after a migration)
  file { "security-config.properties_tenant_${tenant_id}":
    path    => "${bonita_bpm::params::home}/client/tenants/${tenant_id}/conf/security-config.properties",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    source  => "puppet:///modules/bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/security-config.properties",
    require => File["${bonita_bpm::params::home}/client/tenants/${tenant_id}/conf/"],
    notify  => Service[$bonita_bpm::params::service_name],
  }
  # Activate dynamic permissions checks
  file { "dynamic-permissions-checks.properties_${tenant_id}":
    path    => "${bonita_bpm::params::home}/client/tenants/${tenant_id}/conf/dynamic-permissions-checks.properties",
    mode    => '0644',
    owner   => $bonita_bpm::params::app_srv_user,
    group   => $bonita_bpm::params::app_srv_group,
    source  => "puppet:///modules/bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/dynamic-permissions-checks.properties",
    require => File["${bonita_bpm::params::home}/client/tenants/${tenant_id}/conf/"],
    notify  => Service[$bonita_bpm::params::service_name],
  }

  $tenant_admin_user = $name['user']
  $tenant_admin_pass = $name['pass']

  if $bonita_bpm::params::major_version == '6' {
    # apply workers template at tenant level since 6.3.0
    file { "workers_conf_tenant_${tenant_id}":
      path    => "${bonita_bpm::params::home}/server/tenants/${tenant_id}/conf/services/cfg-bonita-work-factory.xml.erb",
      mode    => '0644',
      owner   => $bonita_bpm::params::app_srv_user,
      group   => $bonita_bpm::params::app_srv_group,
      content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/cfg-bonita-work-factory.xml.erb"),
      require => File["${bonita_bpm::params::home}/server/tenants/${tenant_id}/conf/services/"],
      notify  => Service[$bonita_bpm::params::service_name],
    }
    # apply connectors template if available (performance edition and version >= 6.1)
    if $bonita_bpm::params::connectors_tpl != undef {
      file { "connectors_conf_tenant_${tenant_id}":
        path    => "${bonita_bpm::params::home}/server/tenants/${tenant_id}/conf/services/${bonita_bpm::params::connectors_file}",
        mode    => '0644',
        owner   => $bonita_bpm::params::app_srv_user,
        group   => $bonita_bpm::params::app_srv_group,
        content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/${bonita_bpm::params::connectors_tpl}"),
        require => File["${bonita_bpm::params::home}/server/tenants/${tenant_id}/conf/services/"],
        notify  => Service[$bonita_bpm::params::service_name],
      }
    }
    # apply bonita-server template to set tenant credentials
    # this handles also datamanagement conf if available (performance edition and version >= 6.3)
    if $bonita_bpm::edition == 'performance' {
      $businessdata_ds_jndi           = $name['business_data']['ds']['name']
      $businessdata_dsxa_jndi         = $name['business_data']['dsxa']['name']
      $businessdata_hibernate_dialect = $name['business_data']['ds_common']['hibernate_dialect']
    }
    file { "bonita_server_conf_tenant_${tenant_id}":
      path    => "${bonita_bpm::params::home}/server/tenants/${tenant_id}/conf/bonita-server.properties",
      mode    => '0644',
      owner   => $bonita_bpm::params::app_srv_user,
      group   => $bonita_bpm::params::app_srv_group,
      content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/bonita-server.properties.erb"),
      require => File["${bonita_bpm::params::home}/server/tenants/${tenant_id}/conf"],
      notify  => Service[$bonita_bpm::params::service_name],
    }
  } else {
    # this handles also datamanagement conf if available (all editions since version 7.0)
    $businessdata_db_vendor         = $name['business_data']['ds_common']['db_vendor']
    $businessdata_ds_jndi           = $name['business_data']['ds']['name']
    $businessdata_dsxa_jndi         = $name['business_data']['dsxa']['name']

    # apply community conf
    file { "bonita-tenant-community-custom_${tenant_id}":
      path    => "${bonita_bpm::params::home}/engine-server/conf/tenants/${tenant_id}/bonita-tenant-community-custom.properties",
      mode    => '0644',
      owner   => $bonita_bpm::params::app_srv_user,
      group   => $bonita_bpm::params::app_srv_group,
      content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/bonita-tenant-community-custom.properties.erb"),
      require => Exec['copy_bonita_conf'],
      notify  => Service[$bonita_bpm::params::service_name],
    }
    # if needed apply sp conf
    if $bonita_bpm::edition == 'performance' {
      file { "bonita-tenant-sp-custom_${tenant_id}":
        path    => "${bonita_bpm::params::home}/engine-server/conf/tenants/${tenant_id}/bonita-tenant-sp-custom.properties",
        mode    => '0644',
        owner   => $bonita_bpm::params::app_srv_user,
        group   => $bonita_bpm::params::app_srv_group,
        content => template("bonita_bpm/bonita/${bonita_bpm::edition}/${bonita_bpm::version}/bonita-tenant-sp-custom.properties.erb"),
        require => Exec['copy_bonita_conf'],
        notify  => Service[$bonita_bpm::params::service_name],
      }
    }
  }
}
