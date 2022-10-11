# operational dashboard
class profile::dashboard (
  Optional[Sensitive[String]] $influxdb_token,
  String $influxdb_token_name,
  String $influxdb_host,
  Integer $influxdb_port,
  String $influxdb_org,
  String $influxdb_bucket,
  Boolean $use_ssl,
) {
  $influxdb_token_file = lookup(influxdb::token_file, undef, undef, $facts['identity']['user'] ? {
      'root'  => '/root/.influxdb_token',
      default => "/home/${facts['identity']['user']}/.influxdb_token"
  })
  unless $facts['toml-rb_installed'] {
    warning('toml-rb gem is not installed - not managing puppet_operational_dashboards')
    package { 'toml-rb':
      ensure   => 'present',
      provider => 'puppetserver_gem',
      notify   => Service['pe-puppetserver'],
    }
    file { '/opt/puppetlabs/facter/facts.d/toml-rb_installed.sh':
      ensure  => file,
      mode    => '0500',
      content => @(EOS)
      #!/bin/bash
      echo toml-rb_installed=`/opt/puppetlabs/bin/puppetserver gem list toml-rb -i`
      | EOS
    }
  } else {
    if $influxdb_host == $facts['networking']['fqdn'] {
      class { 'influxdb':
        host        => $influxdb_host,
        port        => $influxdb_port,
        use_ssl     => $use_ssl,
        initial_org => $influxdb_org,
        token_file  => $influxdb_token_file,
      }
  
      influxdb_org { $influxdb_org:
        ensure     => present,
        use_ssl    => $use_ssl,
        token      => $influxdb_token,
        require    => Class['influxdb'],
        token_file => $influxdb_token_file,
      }
      influxdb_bucket { $influxdb_bucket:
        ensure     => present,
        use_ssl    => $use_ssl,
        org        => $influxdb_org,
        token      => $influxdb_token,
        require    => [Class['influxdb'], Influxdb_org[$influxdb_org]],
        token_file => $influxdb_token_file,
      }
  
      Influxdb_auth {
        require => Class['influxdb'],
      }
          # Create a token with permissions to read and write timeseries data
      # The influxdb::retrieve_token() function cannot find a token during the catalog compilation which creates it
      #   i.e. it takes two agent runs to become available
      influxdb_auth { $token_name:
        ensure      => present,
        use_ssl     => $use_ssl,
        org         => $influxdb_org,
        token       => $influxdb_token,
        token_file  => $influxdb_token_file,
        permissions => [
          {
            'action'   => 'read',
            'resource' => {
              'type'   => 'telegrafs',
            }
          },
          {
            'action'   => 'write',
            'resource' => {
              'type'   => 'telegrafs',
            }
          },
          {
            'action'   => 'read',
            'resource' => {
              'type'   => 'buckets',
            }
          },
          {
            'action'   => 'write',
            'resource' => {
              'type'   => 'buckets',
            }
          },
        ],
      }
      include puppet_operational_dashboards::enterprise_infrastructure
      include puppet_operational_dashboards::profile::dashboards
    }
  }
  class { 'puppet_operational_dashboards::telegraf::agent':
    influxdb_host       => $influxdb_host,
    token               => $influxdb_token,        
    token_name          => $influxdb_token_name,
    influxdb_token_file => $influxdb_token_file, 
    influxdb_port       => $influxdb_port,
    influxdb_org        => $influxdb_org,  
    influxdb_bucket     => $influxdb_bucket,
    use_ssl             => $use_ssl,
  }
}




