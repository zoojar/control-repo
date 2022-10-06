# operational dashboard
class profile::dashboard {
  include puppet_operational_dashboards::enterprise_infrastructure
  include puppet_operational_dashboards
  ensure_packages(
    ['toml-rb'],
    { ensure   => 'present',
      provider => 'puppetserver_gem',
      before   => [
        Class['puppet_operational_dashboards'],
        Class['puppet_operational_dashboards::enterprise_infrastructure']
      ],
      notify => Service['pe-puppetserver'],
      
    }
  )
}
