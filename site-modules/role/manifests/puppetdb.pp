# puppetdb
class role::puppetdb {
  include profile::base
  #include postgresql::globals
  #include postgresql::server
  include puppetdb
  Service['puppet'] -> Class['puppetdb']
  Service['puppet'] -> Class['puppetdb::database::ssl_configuration']
}
