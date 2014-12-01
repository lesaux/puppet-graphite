# == Class: graphite::prereqs
#
# This class installs epel repo on redhat distros
#
# === Parameters
#
# None.
#
class graphite::prereqs {

  case $::osfamily {
    'redhat': {
      include epel
    }
  }

  ensure_packages ( $::graphite::params::graphitepkgs )

}
