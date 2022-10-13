# operational dashboard
class profile::dashboard (
  Boolean $agent_only = true,
) {
  if $facts['toml_rb_gem']['gem_installed'] {
    include puppet_operational_dashboards::enterprise_infrastructure
    if $agent_only {
      include 'puppet_operational_dashboards::telegraf::agent'
    } else {
      include puppet_operational_dashboards
    }
  } else {
    warning('toml-rb gem is not installed - not managing puppet_operational_dashboards')
    package { 'toml-rb':
      ensure   => 'present',
      provider => 'puppetserver_gem',
      notify   => Service['pe-puppetserver'],
    }
  }
}
