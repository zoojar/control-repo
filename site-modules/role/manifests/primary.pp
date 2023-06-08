# puppetserver
class role::primary {
  include profile::base
  include puppet::server::puppetdb   # for server config
  include r10k
  include ssh
  include foreman::repo
  include foreman_proxy
  Group['puppet'] -> Class['foreman_proxy']  # issue in foreman_proxy module: https://github.com/theforeman/puppet-foreman_proxy/issues/295
  Class['foreman::repo'] -> Class['foreman_proxy']
}
