class graphite::carbonate (

  $destination			= '/opt/graphite/conf',
  $gr_carbonate_clustername     = 'main',
  $gr_carbonate_servers         = undef,
  $gr_carbonate_repfactor       = '2',
  $gr_carbonate_user            = 'carbon',

) {

  if $::graphite::gr_install_carbonate {
    package{'carbonate':
      ensure   => present,
      provider => pip,
    }
    file { "${destination}/carbonate.conf":
      ensure => file,
      content => template('graphite/opt/graphite/conf/carbonate.conf.erb'),
      owner   => root,
      group   => root,
    }
  } else {
    package{'carbonate':
      ensure   => absent,
      provider => pip,
    }
  }

}
