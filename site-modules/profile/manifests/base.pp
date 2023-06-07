# The base profile should include component modules that will be on all nodes
class profile::base {
  include accounts
  include puppet

  # Fix multipath issue in focal on
  $multipath_conf = @(END)
    defaults {
      user_friendly_names yes
    }
    
    blacklist {
      devnode "^(sda|sdb)[0-9]*"
    }
  | END 

  file { '/etc/multipath.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => $multipath_conf,
    notify  => Service['multipath-tools']
  }
  service { 'multipath-tools':
    ensure => running,
  }
  file_line { 'bashrc_proxy':
    path => '/root/.bashrc',
    line => 'export PATH=$PATH:/opt/puppetlabs/bin',
  }
}
