# puppetdb role - placeholder until foreman groups
class role::puppetdb {
  include profile::base
  include puppetdb
  include foreman::repo
  include foreman
  Class['foreman::repo'] -> Class['foreman']
}
