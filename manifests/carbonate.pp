class graphite::carbonate {

  if $::graphite::gr_install_carbonate {
    package{'carbonate':
      ensure   => present,
      provider => pip,
    }
  } else {
    package{'carbonate':
      ensure   => absent,
      provider => pip,
    }
  }

}
