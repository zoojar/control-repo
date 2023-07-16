# The base profile should include component modules that will be on all nodes
class profile::r10k (
  String $remote  = 'git@github.com:zoojar/control-repo.git',
  #String $ssh_key = , 
  String $r10k_user = 'r10k',
){
  class { 'sudo':
    purge               => false,
    config_file_replace => false,
  }
  sudo::conf { 'r10k':
    priority => 10,
    content  => "${r10k_user} ALL=(ALL) NOPASSWD:/opt/puppetlabs/puppet/bin/r10k",
    require  => User[$r10k_user],
  }
  user { $r10k_user:
    ensure     => present,
    gid        => $r10k_user,
    comment    => 'r10k deployment',
    shell      => '/bin/bash',
    managehome => true,
    home       => "/home/${r10k_user}",
  }
  # Create the r10k group
  group { $r10k_user:
    ensure => present,
  }
  #file { "/home/${r10k_user}/.ssh":
  #  ensure => directory,
  #  owner  => $r10k_user,
  #  group  => $r10k_user,
  #}
  #file { 'r10k_ssh_key':
  #  ensure => file,
  #  path   => $ssh_key,
  #  owner  => $r10k_user,
  #  group  => $r10k_user,
  #  mode   => '0600',
  #}
  #ssh::config_entry { 'r10k github.com':
  #  ensure => present,
  #  path   => '/root/.ssh/config',
  #  owner  => 'root',
  #  group  => 'root',
  #  host   => 'github.com',
  #  lines  => [
  #    '  User git',
  #    "  IdentityFile ${ssh_key}",
  #    '  ForwardX11 no',
  #    '  StrictHostKeyChecking no',
  #  ],
  #}
}
