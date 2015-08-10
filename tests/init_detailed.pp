Exec { path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
  # Bonita BPM
  # mandatory parameters
  $bonita_bpm_version                          = '7.0.2'
  $bonita_bpm_edition                          = 'performance'
  $bonita_bpm_archive                          = 'BonitaBPMSubscription-7.0.2.tgz'
  # the license is not mandatory if edition is equal to community
  $bonita_bpm_license                          = 'license.lic'
  # database parameters used for bonitaDS and bonitaSequenceManagerDS
  $bonita_bpm_db_vendor                        = 'postgres'
  $bonita_bpm_db_name                          = 'bonitadb'
  $bonita_bpm_db_user                          = 'bonitauser'
  $bonita_bpm_db_pass                          = 'bonitapass'
  $bonita_bpm_db_host                          = '127.0.0.1'
  $bonita_bpm_db_port                          = '5432'
  $bonita_bpm_bonitaDS_minIdle                 = '5'
  $bonita_bpm_bonitaDS_maxActive               = '31'
  $bonita_bpm_bonitaSequenceManagerDS_minIdle   = '1'
  $bonita_bpm_bonitaSequenceManagerDS_maxActive = '3'
  # optional datasource for custom needs
  $bonita_bpm_CustomDS_db_vendor              = 'postgres'
  $bonita_bpm_CustomDS_name                   = 'customdb'
  $bonita_bpm_CustomDS_user                   = 'customuser'
  $bonita_bpm_CustomDS_pass                   = 'custompass'
  $bonita_bpm_CustomDS_host                   = '127.0.0.1'
  $bonita_bpm_CustomDS_port                   = '5432'
  $bonita_bpm_CustomDS_minIdle                = '5'
  $bonita_bpm_CustomDS_maxActive              = '10'
  # platform credentials
  $bonita_bpm_platform_admin_user               = 'platformadmin'
  $bonita_bpm_platform_admin_pass               = 'platformsecret'
  # jvm and tomcat tuning
  $bonita_bpm_java_opts                         = '-Djava.awt.headless=true -XX:+UseConcMarkSweepGC -Dfile.encoding=UTF-8 -Xshare:auto -Xms512m -Xmx512m -XX:MaxPermSize=128m -XX:+HeapDumpOnOutOfMemoryError'
  $bonita_bpm_jmx_pass                          = 'jmxsecret'
  $bonita_bpm_maxThreads                        = '150'
  $bonita_bpm_server_info                       = 'Apache Tomcat'
  # bonita workers configuration
  $bonita_bpm_corePoolSize                      = '8'
  $bonita_bpm_maximumPoolSize                   = '8'
  # bonita connectors configuration
  $bonita_bpm_connectorTimeout                  = '300'
  # quartz configuration
  $bonita_bpm_quartz_threadCount                = '5'
  # tenants configuration
  $bonita_bpm_tenants = [
              { id        => '1',
                user      => 'tech_user',
                pass      => 'tenantsecret',
                business_data => {
                  ds        => {
                    name            => 'NotManagedBizDataDS',
                    minIdle         => '1',
                    maxActive       => '5',
                    driverClassName => 'org.postgresql.Driver',
                  },
                  dsxa      => {
                    name        => 'BusinessDataDS',
                    minPoolSize => '0',
                    maxPoolSize => '5',
                    className   => 'org.postgresql.xa.PGXADataSource',
                  },
                  ds_common => {
                    db_vendor => 'postgres',
                    db_user   => 'datamanagementuser',
                    db_pass   => 'datamanagementpass',
                    db_name   => 'datamanagementdb',
                    db_host   => '127.0.0.1',
                    db_port   => '5432',
                    testQuery => 'SELECT 1',
                  }
                }
              }
  ]

  $bonita_bpm_logs_user                             = 'logsuser'
  $bonita_bpm_logs_pass                             = 'logssecret'

  # deploy Bonita BPM
  include bonita_bpm
  # deploy ROOT application
  include bonita_bpm::root_application
  # deploy LOGS application
  include bonita_bpm::logs_application
