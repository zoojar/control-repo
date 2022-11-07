# The base profile should include component modules that will be on all nodes
class profile::base {
  package { 'toml-rb':
    ensure   => '2.1.1',
    provider => 'puppetserver_gem',
    notify   => Service['pe-puppetserver'],
  }
}
