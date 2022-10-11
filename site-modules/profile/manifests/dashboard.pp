# operational dashboard
class profile::dashboard (
  Optional[Sensitive[String]] $token,
  String $token_name,
  String $influxdb_host,
  Integer $influxdb_port,
  String $influxdb_org,
  String $influxdb_bucket,
  Boolean $use_ssl,
) {
  unless $facts['toml-rb_installed'] {
    warning('toml-rb gem is not installed - not managing puppet_operational_dashboards')
    package { 'toml-rb':
      ensure   => 'present',
      provider => 'puppetserver_gem',
      notify   => Service['pe-puppetserver'],
    }
  } else {
    include puppet_operational_dashboards::enterprise_infrastructure
    class { 'puppet_operational_dashboards':
      influxdb_host         => $influxdb_host,
      influxdb_port         => $influxdb_port,
      initial_org           => $influxdb_org,
      initial_bucket        => $influxdb_bucket,
      influxdb_token        => $influxdb_token,
      telegraf_token        => undef,
      telegraf_token_name   => 'puppet telegraf token',
      influxdb_token_file   => $facts['identity']['user'] ? {
          'root'  => '/root/.influxdb_token',
          default => "/home/${facts['identity']['user']}/.influxdb_token"
        },
      manage_telegraf       => false,
      manage_telegraf_token => true,
      use_ssl               => true,
    }
    class { 'puppet_operational_dashboards::telegraf::agent':
      influxdb_host   => $influxdb_host,
      token           => $influxdb_token,        
      token_name      => $influxdb_token_name,   
      influxdb_port   => $influxdb_port,
      influxdb_org    => $influxdb_org,  
      influxdb_bucket => $influxdb_bucket, 
      use_ssl         => $use_ssl,
      require         => Class['puppet_operational_dashboards'],
    }
  }
  file { '/opt/puppetlabs/facter/facts.d/toml-rb_installed.sh':
    ensure  => file,
    mode    => '0500',
    content => @(EOS)
      #!/bin/bash
      echo toml-rb_installed=`/opt/puppetlabs/bin/puppetserver gem list toml-rb -i`
      | EOS
  }
}
