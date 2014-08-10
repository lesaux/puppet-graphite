define graphite::carbon(
  $carbonname       = $name,
  $carbontype       = relay,
  $conf             = {},
) {



  validate_string($carbonname)
  validate_string($carbontype)
  validate_hash($conf)

  file { "init file ${carbontype} ${carbonname}":
    ensure  => file,
    name    => "/etc/init.d/carbon-${carbontype}_${carbonname}",
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template("${module_name}/etc/init.d/carbon.init.erb"),
    notify  => Service["carbon ${carbontype} ${carbonname}"],
  }

  file { "conf file ${carbontype} ${carbonname}":
    ensure  => file,
    name    => "/opt/graphite/conf/carbon-${carbontype}_${carbonname}.conf",
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template("${module_name}/opt/graphite/conf/carbon.conf.erb"),
    notify  => Service["carbon ${carbontype} ${carbonname}"],
    #require    => File["init file ${carbontype} ${carbonname}"];
  }

  service { "carbon ${carbontype} ${carbonname}":
    ensure     => running,
    name       => "carbon-${carbontype}_${carbonname}",
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    #require    => File["conf file ${carbontype} ${carbonname}"];
    #status     => "/bin/service carbon-${carbontype}_${carbonname} status | grep --quiet \"is running\"",
  }

}
