class graphite::carbons($gr_carbon_daemons) {

  #require graphite::install

  validate_hash($gr_carbon_daemons)

  if $::graphite::gr_enable_carbon_relay {
    file {
      '/opt/graphite/conf/relay-rules.conf':
        #mode => '0644',
        mode => '0744',
        content => template('graphite/opt/graphite/conf/relay-rules.conf.erb'),
        #notify => $notify_services;
    }
  }

  if $::graphite::gr_enable_carbon_aggregator {

    file {
      '/opt/graphite/conf/aggregation-rules.conf':
      mode    => '0644',
      content => template('graphite/opt/graphite/conf/aggregation-rules.conf.erb'),
      notify  => $notify_services;
    }
  }


create_resources('graphite::carbon', $gr_carbon_daemons)

}