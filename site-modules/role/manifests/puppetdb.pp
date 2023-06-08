# puppetdb role - placeholder until foreman groups
class role::puppetdb {
  include profile::base
  include puppetdb
  #include foreman
}
