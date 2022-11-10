# dashboard agent
class profile::dashboard_agent (
  Optional[Sensitive[String]] $telegraf_agent_token,
  String $influxdb_host,
) {
  # puppet_operational_dashboards module uses the influxdb toml() function,
  # which depends on the toml-rb gem,
  # this causes compilation to fail unless installed
  if $facts['toml_rb_gem_status']['gem_installed'] {
    include puppet_operational_dashboards::enterprise_infrastructure
    class { 'puppet_operational_dashboards::telegraf::agent':
      token_name          => 'puppet telegraf token',
      token               => undef, # $telegraf_agent_token,
      influxdb_token_file => '/root/.influxdb_token',
      influxdb_host       => $influxdb_host,
      influxdb_port       => 8086,
      influxdb_bucket     => 'puppet_data',
      influxdb_org        => 'puppetlabs',
      use_ssl             => true,
    }
  } else {
    warning('toml-rb gem is not installed - attempting to manage...')
    package { 'toml-rb':
      ensure   => '2.1.1',
      provider => 'puppetserver_gem',
      notify   => Service['pe-puppetserver'],
    }
  }
}

