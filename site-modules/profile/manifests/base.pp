# The base profile should include component modules that will be on all nodes
class profile::base {
  class {'::puppet_agent':
    package_version => '6.28.0',
    collection      => 'puppet6',
  }
}
