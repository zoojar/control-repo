# operational dashboard
class profile::dashboard {
  class { 'puppet_operational_dashboards':
    manage_telegraf => false,
  }
}
