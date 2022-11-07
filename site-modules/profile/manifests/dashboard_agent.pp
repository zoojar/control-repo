# dashboard agent
class profile::dashboard_agent (
  Optional[Sensitive[String]] $telegraf_agent_token,
  String $influxdb_host,
) {
  package { 'toml-rb':
    ensure   => '2.1.1',
    provider => 'puppetserver_gem',
    notify   => Service['pe-puppetserver'],
  }
  class { 'puppet_operational_dashboards::profile::postgres_access':
    require  => Package['toml-rb'],
  }
  class { 'puppet_operational_dashboards::telegraf::agent':
    token_name          => 'puppet telegraf token',
    token               => $telegraf_agent_token,
    influxdb_token_file => '/root/.influxdb_token',
    influxdb_host       => $influxdb_host,
    influxdb_port       => 8086,
    influxdb_bucket     => 'puppet_data',
    influxdb_org        => 'puppetlabs',
    use_ssl             => true,
    require             => Package['toml-rb'],
  }

}

