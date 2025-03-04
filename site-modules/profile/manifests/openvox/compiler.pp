# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::openvox::compiler
# @param ca_conf puppetserver ca.cfg 
class profile::openvox::compiler (
  String $ca_conf = '/etc/puppetlabs/puppetserver/services.d/ca.cfg',
) {
  file_line { 'certificate-authority-disabled-service':
    ensure => present,
    path   => $ca_conf,
    line   => 'puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service',
    notify => Service['puppetserver'],
  }
  file_line { 'puppetlabs.services.ca.certificate-authority-service/certificate-authority-service':
    ensure            => absent,
    path              => $ca_conf,
    match             => '^puppetlabs.services.ca.certificate-authority-disabled-service/certificate-authority-disabled-service',
    match_for_absence => true,
    notify            => Service['puppetserver'],
  }
  service { 'puppetserver':
    ensure => 'running',
  }
}
