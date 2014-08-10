#graphite

###Warning

This work is not complete yet, but it should work. I haven't worked on the carbon-aggregator yet.

###Overview

This is a fork from the excellent graphite module created by dwerder. For further details on all the parameters, you should visit https://forge.puppetlabs.com/dwerder/graphite.

The idea is to make it possible to configure more advanced graphite architectures.
I've created a simple graphite::carbon resource, which is used by the graphite::carbons class.

###Usage


To setup a node, you would need to include the graphite class, as well as the graphite::carbons class.
You need to declare your setup in the form of a hash.


###Examples
In the dwerder/graphite module, a single carbon-cache is configured. Here, a configuration equivalent to this setup would be:

```
a:
  type: cache
  conf:
    cache_write_strategy: sorted
    max_cache_size: inf
    use_flow_control: True
    whisper_fallocate_create: True
    max_creates_per_minute: 3000
    max_updates_per_second: 10000
    line_receiver_interface: 0.0.0.0
    line_receiver_port: 2103
    pickle_receiver_interface: 0.0.0.0
    pickle_receiver_port: 2104
    use_insecure_unpickler: False
    cache_query_interface: 0.0.0.0
    cache_query_port: 7002
    log_cache_hits: False
    log_cache_queue_sorts: True
    log_listener_connections: True
    log_updates: False
    enable_logrotation: True
    whisper_autoflush: False
```

But you can also cover more complex graphite architectures, such as:

```
                                       LoadBalancer
                                       +          +
                                       |          |
                    +------------------+          +-------------------- 
                    |                                                 |
                    v                                                 v
       carbon-relay-replication                               carbon-relay-replication
                  +   +                                               +    +
                  |   |                                               |    |
                  |   |                                               |    |
                  |   +--------------------------------------------+  |    |
 GRAPHITE NODE 1  |                                                |  |    | GRAPHITE NODE 2
                  |   +-----------------------------------------------+    |
                  |   |                                            |       |
                  |   |                                            |       |
                  v   v                                            v       v
        carbon-relay-fanout                                      carbon-relay-fanout
        +                 +                                      +                 +  
        |                 |                                      |                 |
        |                 |                                      |                 |                  
        v                 v                                      v                 v                                  
carbon-cache-a       carbon-cache-b                     carbon-cache-a             carbon-cache-b
```

With a hash such as this one:

```
rep:
  type: relay
  conf:
    line_receiver_interface: 0.0.0.0
    line_receiver_port: 2213
    pickle_receiver_interface: 0.0.0.0
    pickle_receiver_port: 2214
    relay_method: consistent-hashing
    replication_factor: 2
    destinations: graphite-0:2414:fan, graphite-1:2414:fan
    max_datapoints_per_message: 500
    max_queue_size: 100000
    use_flow_control: true
fan:
  type: relay
  conf:
    line_receiver_interface: 0.0.0.0
    line_receiver_port: 2413
    pickle_receiver_interface: 0.0.0.0
    pickle_receiver_port: 2414
    relay_method: consistent-hashing
    replication_factor: 2
    destinations: localhost:2104:1, localhost:2204:2
    max_datapoints_per_message: 500
    max_queue_size: 100000
    use_flow_control: true
a:
  type: cache
  conf:
    cache_write_strategy: sorted
    max_cache_size: inf
    use_flow_control: True
    whisper_fallocate_create: True
    max_creates_per_minute: 3000
    max_updates_per_second: 10000
    line_receiver_interface: 0.0.0.0
    line_receiver_port: 2103
    pickle_receiver_interface: 0.0.0.0
    pickle_receiver_port: 2104
    use_insecure_unpickler: False
    cache_query_interface: 0.0.0.0
    cache_query_port: 7002
    log_cache_hits: False
    log_cache_queue_sorts: True
    log_listener_connections: True
    log_updates: False
    enable_logrotation: True
    whisper_autoflush: False
b:
  type: cache
  conf:
    cache_write_strategy: sorted
    max_cache_size: inf
    use_flow_control: True
    whisper_fallocate_create: True
    max_creates_per_minute: 3000
    max_updates_per_second: 10000
    line_receiver_interface: 0.0.0.0
    line_receiver_port: 2203
    pickle_receiver_interface: 0.0.0.0
    pickle_receiver_port: 2204
    use_insecure_unpickler: False
    cache_query_interface: 0.0.0.0
    cache_query_port: 7202
    log_cache_hits: False
    log_cache_queue_sorts: True
    log_listener_connections: True
    log_updates: False
    enable_logrotation: True
    whisper_autoflush: False	
```
