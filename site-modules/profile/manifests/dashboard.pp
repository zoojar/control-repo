# operational dashboard
class profile::dashboard {
  if $facts['toml_gem_installed'] {
    include puppet_operational_dashboards::enterprise_infrastructure
    include puppet_operational_dashboards
  } else {
    warning('toml-rb gem is not installed - not managing puppet_operational_dashboards')
  }
  package { 'toml-rb':
    ensure   => 'present',
    provider => 'puppetserver_gem',
    notify   => Service['pe-puppetserver'],
  }
}
