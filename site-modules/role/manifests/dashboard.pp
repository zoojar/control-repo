# puppetserver
class role::dashboard {
  class { 'profile::dashboard':
    require => Class['profile::dashboard_agent']
  }
  class { 'profile::dashboard_agent': }
}
