class graphite::carbonate (

  $destination			= '/opt/graphite/conf',
  $gr_carbonate_clustername     = $::graphite::gr_carbonate_clustername,
  $gr_carbonate_servers         = $::graphite::gr_carbonate_servers,
  $gr_carbonate_repfactor       = $::graphite::gr_carbonate_repfactor,
  $gr_carbonate_user            = $::graphite::gr_carbonate_user,

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
