Exec { path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
class { 'bonita_bpm':
    version         => '6.4.0',
    edition         => 'community',
    archive         => 'BonitaBPMCommunity-6.4.0.tgz',
}
