# puppetdb
class role::puppetdb {
  include deploy_puppet::base
  #include postgresql::globals
  #include postgresql::server
  include puppetdb
  Service['puppet'] -> Class['puppetdb']
  Service['puppet'] -> Class['puppetdb::database::ssl_configuration']
}
