Exec { path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
class { 'bonita_bpm':
    version         => '6.5.2',
    edition         => 'community',
    archive         => 'BonitaBPMCommunity-6.5.2.tgz',
}
