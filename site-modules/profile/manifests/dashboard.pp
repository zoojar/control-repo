# operational dashboard
class profile::dashboard {
  if $facts['toml-rb_installed'] {
    include puppet_operational_dashboards::enterprise_infrastructure
    include puppet_operational_dashboards
    class { 'puppet_operational_dashboards::telegraf::agent':
      influxdb_host => 'puppetserver1.lab.local',
      token         => Sensitive('KKpcL9OER9UwBnitvBK38hMWRp7aKp9VzkZHSvzovqmXGBBXJcBRXTekskCFL1n-DwJKNJQnI8vmp1R7L6WWwA=='),
      require       => Class['puppet_operational_dashboards'],
    }
x
  } else {
    warning('toml-rb gem is not installed - not managing puppet_operational_dashboards')
    package { 'toml-rb':
      ensure   => 'present',
      provider => 'puppetserver_gem',
      notify   => Service['pe-puppetserver'],
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
