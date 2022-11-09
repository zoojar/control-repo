# dashboard agent
class profile::dashboard_agent (
  String $influxdb_host,
  String $telegraf_agent_token_file = '/root/.telegraf_agent_token',
  Optional[Sensitive[String]] $telegraf_agent_token = undef,
) {
  $test=Deferred('find_file', [$telegraf_agent_token_file])
  if ($telegraf_agent_token == undef) and (Deferred('find_file', [$telegraf_agent_token_file]) != undef) {
    notify {"test:${test}":}
    #$_telegraf_agent_token = Deferred('file', [$telegraf_agent_token_file])
  } else {
    $_telegraf_agent_token = $telegraf_agent_token
  }
  # puppet_operational_dashboards module uses the to_toml() function,
  # which depends on the toml-rb gem,
  # this causes compilation to fail unless installed
  if $facts['toml_rb_gem_status']['gem_installed'] {
    include puppet_operational_dashboards::enterprise_infrastructure
    class { 'puppet_operational_dashboards::telegraf::agent':
      token_name          => 'puppet telegraf token',
      token               => $_telegraf_agent_token,
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

