Exec { path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
class { 'bonita_bpm':
    version         => '6.5.3',
    edition         => 'community',
    archive         => 'BonitaBPMCommunity-6.5.3.tgz',
}
