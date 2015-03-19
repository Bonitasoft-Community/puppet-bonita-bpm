# Class: bonita_bpm::params
#
# This class defines and validates bonita_bpm parameters
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
class bonita_bpm::params {

  # raise error for mandatory parameters (see version and edition treatment below)
  if $bonita_bpm::archive == undef {
    fail('Class[\'bonita_bpm::params\']: bonita_bpm::archive is mandatory')
  }

  # define default values
  # database parameters used for bonitaDS and bonitaSequenceManagerDS
  if $bonita_bpm::db_vendor == undef {
    $db_vendor = 'h2'
    if $bonita_bpm::db_user == undef {
      $db_user = 'sa'
      $db_pass = ''
    }
  } else {
    $db_vendor = $bonita_bpm::db_vendor
    $db_user = $bonita_bpm::db_user
    $db_pass = $bonita_bpm::db_pass
  }
  if $bonita_bpm::db_host == undef {
    $db_host = '127.0.0.1'
  } else {
    $db_host = $bonita_bpm::db_host
  }
  if $bonita_bpm::db_port == undef {
    case $db_vendor {
      'h2': {
        $db_port = '9091'
      }
      'mysql': {
        $db_port = '3306'
      }
      'postgres': {
        $db_port = '5432'
      }
      default: {}
    }
  } else {
    $db_port = $bonita_bpm::db_port
  }
  if $bonita_bpm::db_name == undef {
    $db_name = 'bonita_journal.db'
  } else {
    $db_name = $bonita_bpm::db_name
  }
  if $bonita_bpm::bonitaDS_minIdle == undef {
    $bonitaDS_minIdle = '3'
  } else {
    $bonitaDS_minIdle = $bonita_bpm::bonitaDS_minIdle
  }
  if $bonita_bpm::bonitaDS_maxActive == undef {
    $bonitaDS_maxActive = '20'
  } else {
    $bonitaDS_maxActive = $bonita_bpm::bonitaDS_maxActive
  }
  if $bonita_bpm::bonitaSequenceManagerDS_minIdle == undef {
    $bonitaSequenceManagerDS_minIdle = '1'
  } else {
    $bonitaSequenceManagerDS_minIdle = $bonita_bpm::bonitaSequenceManagerDS_minIdle
  }
  if $bonita_bpm::bonitaSequenceManagerDS_maxActive == undef {
    $bonitaSequenceManagerDS_maxActive = '2'
  } else {
    $bonitaSequenceManagerDS_maxActive = $bonita_bpm::bonitaSequenceManagerDS_maxActive
  }
  # platform credentials
  if $bonita_bpm::platform_admin_user == undef {
    $platform_admin_user = 'platformAdmin'
  } else {
    $platform_admin_user = $bonita_bpm::platform_admin_user
  }
  if $bonita_bpm::platform_admin_pass == undef {
    $platform_admin_pass = 'platform'
  } else {
    $platform_admin_pass = $bonita_bpm::platform_admin_pass
  }
  # jvm and tomcat tuning
  if $bonita_bpm::java_opts == undef {
    $java_opts = '-Djava.awt.headless=true -XX:+UseConcMarkSweepGC -Dfile.encoding=UTF-8 -Xshare:auto -Xms512m -Xmx1024m -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError'
  } else {
    $java_opts = $bonita_bpm::java_opts
  }
  if $bonita_bpm::jmx_pass == undef {
    $jmx_pass = ''
  }
  if $bonita_bpm::maxThreads == undef {
    $maxThreads = '150'
  } else {
    $maxThreads = $bonita_bpm::maxThreads
  }
  if $bonita_bpm::RemoteIpValve_internalProxies == undef {
    $RemoteIpValve_internalProxies = ''
  } else {
    $RemoteIpValve_internalProxies = $bonita_bpm::RemoteIpValve_internalProxies
  }
  if $bonita_bpm::AccessLogValve_pattern == undef {
    $AccessLogValve_pattern = '%a %{X-Forwarded-For}i %{X-Forwarded-Proto}i %l %u %t &quot;%r&quot; %s %b'
  } else {
    $AccessLogValve_pattern = $bonita_bpm::AccessLogValve_pattern
  }

  # bonita workers configuration
  if $bonita_bpm::corePoolSize == undef {
    $corePoolSize = '8'
  } else {
    $corePoolSize = $bonita_bpm::corePoolSize
  }
  if $bonita_bpm::maximumPoolSize == undef {
    $maximumPoolSize = '8'
  } else {
    $maximumPoolSize = $bonita_bpm::maximumPoolSize
  }
  # bonita connectors configuration
  if $bonita_bpm::connectorTimeout == undef {
    # timeout in seconds, default = 5 minutes
    $connectorTimeout = '300'
  } else {
    $connectorTimeout = $bonita_bpm::connectorTimeout
  }
  # quartz configuration
  if $bonita_bpm::quartz_threadCount == undef {
    $quartz_threadCount = '5'
  } else {
    $quartz_threadCount = $bonita_bpm::quartz_threadCount
  }
  # HTTP API
  if $bonita_bpm::http_api == undef {
    $http_api = 'false'
  } else {
    $http_api = $bonita_bpm::http_api
  }
  # security checks on portal servlets
  if $bonita_bpm::portal_servlet_security_checks == undef {
    $portal_servlet_security_checks = 'true'
  } else {
    $portal_servlet_security_checks = $bonita_bpm::portal_servlet_security_checks
  }
  # tenants configuration
  if $bonita_bpm::tenants == undef {
    $tenants = [
      { id        => '1',
        user      => 'install',
        pass      => 'install',
      }
    ]
  } else {
    $tenants = $bonita_bpm::tenants
  }
  # bonita home path
  if $bonita_bpm::home_parent_dir == undef {
    $home_parent_dir = '/opt/bonita_home'
  } else {
    $home_parent_dir = $bonita_bpm::home_parent_dir
  }

  # manage os dependant variables
  case $::operatingsystem {
    'Ubuntu': {
      $pkg_app_srv   = 'tomcat7'
      $service_name  = 'tomcat7'
      $app_srv_user  = 'tomcat7'
      $app_srv_group = 'tomcat7'
      $app_srv_conf  = '/etc/tomcat7'
      $app_srv_logs  = '/var/log/tomcat7'
      # catalina.home points to the location of the common information
      $catalina_home = '/usr/share/tomcat7'
      # catalina.base points to the directory where all the instance specific information are held
      $catalina_base = '/var/lib/tomcat7'

      $pkg_list = ['openjdk-7-jre-headless', $pkg_app_srv, 'libtcnative-1', 'ttf-dejavu-extra', 'zip']
      $context_path="${app_srv_conf}/Catalina/localhost"
      $setenv_path="${catalina_home}/bin"
      $setenv_file='setenv.sh'
      $home = "${home_parent_dir}/bonita"
      $workers_path = "${home}/server/platform/conf/services"
      $mysql_pkg_driver      = 'libmysql-java'
      $mysql_driver_path     = "${catalina_home}/lib/mysql-connector-java.jar"
      $mysql_driver_target   = '/usr/share/java/mysql-connector-java.jar'
      $pgsql_pkg_driver      = 'libpostgresql-jdbc-java'
      $pgsql_driver_path     = "${catalina_home}/lib/postgresql-jdbc4.jar"
      $pgsql_driver_target   = '/usr/share/java/postgresql-jdbc4.jar'

      $db_opts = "-Dsysprop.bonita.db.vendor=${db_vendor}"
      case $db_vendor {
        'mysql': {
          $db_params       = '?dontTrackOpenResources=true&amp;autoReconnect=true&amp;useUnicode=true&amp;characterEncoding=UTF-8'
          $pkg_driver      = $mysql_pkg_driver
          $driver_path     = $mysql_driver_path
          $driver_target   = $mysql_driver_target
          $driverClassName = 'com.mysql.jdbc.Driver'
          $bt_className    = 'com.mysql.jdbc.jdbc2.optional.MysqlXADataSource'
          $jdbc_url        = "jdbc:${db_vendor}://${db_host}:${db_port}/${db_name}${db_params}"
        }
        'postgres': {
          $db_params       = ''
          $pkg_driver      = $pgsql_pkg_driver
          $driver_path     = $pgsql_driver_path
          $driver_target   = $pgsql_driver_target
          $driverClassName = 'org.postgresql.Driver'
          $bt_className    = 'org.postgresql.xa.PGXADataSource'
          $jdbc_url        = "jdbc:postgresql://${db_host}:${db_port}/${db_name}${db_params}"
        }
        'h2': {
          $db_params       = ';MVCC=TRUE;DB_CLOSE_ON_EXIT=TRUE;IGNORECASE=TRUE;'
          $driverClassName = 'org.h2.Driver'
          $bt_className    = 'org.h2.jdbcx.JdbcDataSource'
          $jdbc_url        = "jdbc:${db_vendor}:tcp://${db_host}:${db_port}/${db_name}${db_params}"
        }
        default: {}
      }
      case $bonita_bpm::businessDS_db_vendor {
        'mysql': {
          $businessDS_db_params       = '?dontTrackOpenResources=true&amp;autoReconnect=true&amp;useUnicode=true&amp;characterEncoding=UTF-8'
          $businessDS_pkg_driver      = $mysql_pkg_driver
          $businessDS_driver_path     = $mysql_driver_path
          $businessDS_driver_target   = $mysql_driver_target
          $businessDS_driverClassName = 'com.mysql.jdbc.Driver'
          $businessDS_jdbc_url        = "jdbc:${bonita_bpm::businessDS_db_vendor}://${bonita_bpm::businessDS_host}:${bonita_bpm::businessDS_port}/${bonita_bpm::businessDS_name}${businessDS_db_params}"
        }
        'postgres': {
          $businessDS_db_params       = ''
          $businessDS_pkg_driver      = $pgsql_pkg_driver
          $businessDS_driver_path     = $pgsql_driver_path
          $businessDS_driver_target   = $pgsql_driver_target
          $businessDS_driverClassName = 'org.postgresql.Driver'
          $businessDS_jdbc_url        = "jdbc:postgresql://${bonita_bpm::businessDS_host}:${bonita_bpm::businessDS_port}/${bonita_bpm::businessDS_name}${businessDS_db_params}"
        }
        default: {
          if $bonita_bpm::businessDS_db_vendor != undef {
            fail("Class['bonita_bpm::params']: this businessDS db vendor (${bonita_bpm::businessDS_db_vendor}) is not yet supported")
          }
        }
      }

    }
    default: {
      fail("Class['bonita_bpm::params']: this operating system (${::operatingsystem}) is not yet supported")
    }
  }

  # manage edition dependant variables
  case $bonita_bpm::edition {
    'teamwork', 'efficiency', 'performance': {
      if $bonita_bpm::license == undef {
        fail("Class['bonita_bpm::params']: a license is mandatory for this edition (${bonita_bpm::edition})")
      }
    }
    default: {}
  }

  # manage version dependant variables
  case $bonita_bpm::version {
    '6.4.0', '6.4.1', '6.4.2', '6.5.0': {
      if $bonita_bpm::edition == 'performance' {
        $connectors_file = 'cfg-bonita-connector-timedout.xml'
        $connectors_tpl  = 'cfg-bonita-connector-timedout.xml.erb'
      }
      if $bonita_bpm::edition == 'community' {
        $connectors_file = 'cfg-bonita-connector-impl.xml'
        $connectors_tpl  = 'cfg-bonita-connector-impl.xml.erb'
      }
    }
    default:{
      fail("Class['bonita_bpm::params']: this version (${bonita_bpm::version}) is not yet supported")
    }
  }

  # check allowed variables
  if $bonita_bpm::edition != 'community' and $bonita_bpm::edition != 'performance' {
    fail('Class[\'bonita_bpm::params\']: edition should be community or performance')
  }
# TODO extend to teamwork and efficiency
# if $bonita_bpm::edition != 'community' and $bonita_bpm::edition != 'teamwork' and $bonita_bpm::edition != 'efficiency' and $bonita_bpm::edition != 'performance' {
#   fail('Class[\'bonita_bpm::params\']: edition should be community, teamwork, efficiency or performance')
# }
  if $db_vendor != 'h2' and $db_vendor != 'mysql' and $db_vendor != 'postgres' {
    fail('Class[\'bonita_bpm::params\']: db_vendor should be h2, mysql or postgres (sqlserver and oracle not yet supported by this module)')
  }

}
