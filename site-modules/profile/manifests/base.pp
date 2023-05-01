# The base profile should include component modules that will be on all nodes
class profile::base {
  class {'::puppet_agent':
    package_version => '7.21.0',
    collection      => 'puppet7',
  }
}
