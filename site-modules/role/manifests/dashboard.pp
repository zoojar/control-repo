# puppetserver
class role::dashboard {
  include profile::base
  include profile::dashboard_agent
  include profile::dashboard

  Class['profile::base']
  ->Class['profile::dashboard_agent']
  ->Class['profile::dashboard']
}
