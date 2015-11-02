bonita_bpm
==========

ABOUT
=====

This module manages [Bonita BPM](http://www.bonitasoft.com) Community or Performance editions. It runs Bonita BPM on tomcat7. Through declaration of the `bonita_bpm` class, you can configure credentials, java_opts, connection pools, bonita workers and connectors.
Currently this module has only been tested on Ubuntu 14.04 using Puppet 3.4.3 and PostgreSQL.

* Bonita BPM editions currently supported : Community, Performance
* Bonita BPM versions currently supported : 6.4.[0-2], 6.5.[0-3], 7.0.[0-3], 7.1.0, 7.1.2

REQUIREMENTS
============

 * A gzip archive which contains the bonita home, libraries and the bonita.war
 * If you install Bonita BPM Performance edition you also need the corresponding license
 * If you don't use H2, an empty database must be created for Bonita BPM before running this module

ARCHIVE CREATION
----------------
 * For Community edition :  
 
        cd /tmp/
        wget http://download.forge.ow2.org/bonita/BonitaBPMCommunity-7.1.2-Tomcat-7.0.55.zip
        unzip BonitaBPMCommunity-7.1.2-Tomcat-7.0.55.zip
        cd BonitaBPMCommunity-7.1.2-Tomcat-7.0.55
        tar -czf BonitaBPMCommunity-7.1.2.tgz bonita/ lib/bonita/ webapps/bonita.war

 * For Performance edition :
    * if version < 7 we need to update the bonita home accordingly
 
            cd /tmp/
            unzip BonitaBPMSubscription-6.5.3-Tomcat-7.0.55.zip
            rm -rf BonitaBPMSubscription-6.5.3-Tomcat-7.0.55/bonita/
            cd BonitaBPMSubscription-6.5.3-Tomcat-7.0.55
            unzip ../bonita-home-sp-6.5.3-performance.zip
            tar -czf BonitaBPMSubscription-6.5.3-performance.tgz bonita/ lib/bonita/ webapps/bonita.war

    * if version >= 7 the bonita home is the same for all subscriptions

            cd /tmp/
            unzip BonitaBPMSubscription-7.1.2-Tomcat-7.0.55.zip
            cd BonitaBPMSubscription-7.1.2-Tomcat-7.0.55
            tar -czf BonitaBPMSubscription-7.1.2.tgz bonita/ lib/bonita/ webapps/bonita.war

LICENSE
-------
Check the documentation for more details http://documentation.bonitasoft.com/licenses

DATABASE CREATION
-----------------
* Example using PostgreSQL :

        sudo -u postgres psql
        CREATE USER bonitauser WITH PASSWORD 'bonitapass';
        CREATE DATABASE bonitadb;
        GRANT ALL PRIVILEGES ON DATABASE "bonitadb" to bonitauser;

INSTALLATION
============
 * Put the target archive (for example: BonitaBPMCommunity-6.5.3.tgz) into bonita_bpm/files/archives/ directory
 * If you install the Bonita BPM Performance edition copy your license into bonita_bpm/files/licenses/ directory

CONFIGURATION
=============

There is one class (bonita_bpm) that needs to be declared on your node to manage your installation of Bonita BPM.
This node is configured using one of two methods.

 1. Using Top Scope parameters 
 2. Using Parameterized Classes

SECURITY
--------
This module ensures to activate both static and dynamic authorization checks on REST API. To be coherent it also deactivates the HTTP API, but you can override this behavior by setting $bonita_bpm_http_api to 'true'.

 * REST API authorization
    * [Static authorization checking](http://documentation.bonitasoft.com/rest-api-authorization#static)
    * [Dynamic authorization checking](http://documentation.bonitasoft.com/rest-api-authorization#dynamic)
 * [HTTP API](http://documentation.bonitasoft.com/rest-api-authorization#activate)

ROOT APPLICATION
----------------
 
In order to redirect access on / to /bonita you can also add the class `bonita_bpm::root_application`      

LOGS APPLICATION
----------------

In order to provide a web access to the logs you can also add the class `bonita_bpm::logs_application`
In this case ensure to set the following variables :

 * bonita_bpm_logs_user 
 * bonita_bpm_logs_pass

Using Top Scope
---------------
Steps:

 1. Add the `bonita_bpm` class to the nodes or groups you want to manage Bonita BPM on.
 2. Add the parameters (See below) to the nodes or groups to configure the `bonita_bpm` class

```puppet
Exec { path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
$bonita_bpm_version = '7.1.2'
$bonita_bpm_edition = 'community'
$bonita_bpm_archive = 'BonitaBPMCommunity-7.1.2.tgz'
include bonita_bpm
```

Using Parameterized Classes
---------------------------
Declaration example:

```puppet
Exec { path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
class { 'bonita_bpm':
  version => '7.1.2',
  edition => 'community',
  archive => 'BonitaBPMCommunity-7.1.2.tgz',
}
```

Parameters
----------

The following lists all the class parameters the bonita_bpm class accepts as well as their Top Scope equivalent.

    bonita_bpm CLASS PARAMETER         TOP SCOPE EQUIVALENT                         DESCRIPTION
    -------------------------------------------------------------------------------------------
    # mandatory parameters
    version                            bonita_bpm_version                           The Bonita BPM version : 6.4.[0-2], 6.5.[0-3], 7.0.[0-3], 7.1.0, 7.1.2
    edition                            bonita_bpm_edition                           The Bonita BPM edition : community, performance
    archive                            bonita_bpm_archive                           The tgz archive which contains bonita home, libs and war file
    # the license is not mandatory if edition is equal to community
    license                            bonita_bpm_license
    # database parameters used for bonitaDS and bonitaSequenceManagerDS
    db_vendor                          bonita_bpm_db_vendor                         h2, mysql, postgres
    db_name                            bonita_bpm_db_name
    db_user                            bonita_bpm_db_user
    db_pass                            bonita_bpm_db_pass
    db_host                            bonita_bpm_db_host
    db_port                            bonita_bpm_db_port
    bonitaDS_minIdle                   bonita_bpm_bonitaDS_minIdle                  The minimum number of established connections that should be kept in the pool at all times
    bonitaDS_maxActive                 bonita_bpm_bonitaDS_maxActive                The maximum number of active connections that can be allocated from this pool at the same time
    bonitaSequenceManagerDS_minIdle    bonita_bpm_bonitaSequenceManagerDS_minIdle   see above
    bonitaSequenceManagerDS_maxActive  bonita_bpm_bonitaSequenceManagerDS_maxActive see above
    # optional datasource for custom needs
    CustomDS_db_vendor                 bonita_bpm_CustomDS_db_vendor              mysql, postgres
    CustomDS_name                      bonita_bpm_CustomDS_name
    CustomDS_user                      bonita_bpm_CustomDS_user
    CustomDS_pass                      bonita_bpm_CustomDS_pass
    CustomDS_host                      bonita_bpm_CustomDS_host
    CustomDS_port                      bonita_bpm_CustomDS_port
    CustomDS_minIdle                   bonita_bpm_CustomDS_minIdle                The minimum number of established connections that should be kept in the pool at all times
    CustomDS_maxActive                 bonita_bpm_CustomDS_maxActive              The maximum number of active connections that can be allocated from this pool at the same time
    # platform credentials
    platform_admin_user                bonita_bpm_platform_admin_user               See doc about [credentials](http://documentation.bonitasoft.com/first-steps-after-setup-0#reset_pw)
    platform_admin_pass                bonita_bpm_platform_admin_pass
    # jvm and tomcat tuning
    java_opts                          bonita_bpm_java_opts
    jmx_pass                           bonita_bpm_jmx_pass
    maxThreads                         bonita_bpm_maxThreads                        The maximum number of request processing threads to be created by the Tomcat Connector, which therefore determines the maximum number of simultaneous requests that can be handled.
    server_info                        bonita_bpm_server_info                       To overwrite the label displaying the Tomcat version in error pages
    RemoteIpValve_internalProxies      bonita_bpm_RemoteIpValve_internalProxies     If set, it activates the [RemoteIpValve](https://tomcat.apache.org/tomcat-7.0-doc/api/org/apache/catalina/valves/RemoteIpValve.html)
    AccessLogValve_pattern             bonita_bpm_AccessLogValve_pattern            The default value is '%a %{X-Forwarded-For}i %{X-Forwarded-Proto}i %l %u %t &quot;%r&quot; %s %b'. See the [pattern codes supported](http://tomcat.apache.org/tomcat-7.0-doc/config/valve.html#Access_Log_Valve/Attributes)
    # bonita workers configuration
    corePoolSize                       bonita_bpm_corePoolSize                      See [Work service documentation](http://documentation.bonitasoft.com/performance-tuning-0#work_service)
    maximumPoolSize                    bonita_bpm_maximumPoolSize
    # bonita connectors configuration
    connectorTimeout                   bonita_bpm_connectorTimeout                  See [Connector service documentation](http://documentation.bonitasoft.com/performance-tuning-0#connector_service)
    # quartz configuration
    quartz_threadCount                 bonita_bpm_quartz_threadCount                See [Scheduler service documentation](http://documentation.bonitasoft.com/performance-tuning-0#scheduler_service)
    # HTTP API
    http_api                           bonita_bpm_http_api                          Set to 'false' by default in order to deactivate the HTTP API
    # security checks on portal servlets
    portal_servlet_security_checks     bonita_bpm_portal_servlet_security_checks    Set to 'true' by default in order to activate security checks also on portal servlets
    # tenants configuration
    tenants                            bonita_bpm_tenants                           See below a detailed example
    # bonita home path
    home_parent_dir                    bonita_bpm_home_parent_dir                   By default /opt/bonita_home

tenants parameter
-----------------
By default the tenants variable is :
```puppet
    $tenants = [
      { id        => '1',
        user      => 'install',
        pass      => 'install',
      }
    ]
```
It allows to set the credentials used by the tenant admin (here in the default tenant with id 1).

For Performance edition and Community edition since 7.0.0, it also permits to configure the database used by the [Data Management feature](http://documentation.bonitasoft.com/database-configuration-business-data-0) :
 * If version < 7 we need to set hibernate_dialect parameter :
```puppet
  $bonita_bpm_tenants = [ 
              { id        => '1',
                user      => 'tech_user',
                pass      => 'secret',
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
                                                  db_user   => 'datamanagementuser',
                                                  db_pass   => 'datamanagementpass',
                                                  db_name   => 'datamanagementdb',
                                                  db_host   => '127.0.0.1',
                                                  db_port   => '5432',
                                                  testQuery => 'SELECT 1',
                                                  hibernate_dialect => 'org.hibernate.dialect.PostgreSQLDialect',
                                                }
                                 }
              }
  ]
```
 * If version >= 7 we need to replace hibernate_dialect parameter by db_vendor :
```puppet
  $bonita_bpm_tenants = [
              { id        => '1',
                user      => 'tech_user',
                pass      => 'secret',
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
```

CONTRIBUTING
============

Before submitting a Pull Request on [GitHub](https://github.com/Bonitasoft-Community/puppet-bonita-bpm) ensure that your patch adheres to the Style Guide using at least `puppet-lint --with-filename --no-80chars-check --no-quoted_booleans-check`
