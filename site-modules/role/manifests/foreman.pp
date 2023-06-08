# foreman - placeholder until foreman groups
class role::foreman {
  include profile::base
  include foreman::repo
  include foreman
  include foreman::plugin::puppet
  Class['foreman::repo'] -> Class['foreman']
  Class['foreman::repo'] -> Class['foreman::plugin::puppet']
}
