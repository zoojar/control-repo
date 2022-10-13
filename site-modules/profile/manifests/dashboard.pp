# operational dashboard
class profile::dashboard (
  Boolean $agent_only = true,
) {
  if $facts['toml-rb_installed'] {
    include puppet_operational_dashboards::enterprise_infrastructure
    unless $agent_only {
      include puppet_operational_dashboards
    } else {
      include 'puppet_operational_dashboards::telegraf::agent'
    }
  } else {
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
  }

}




