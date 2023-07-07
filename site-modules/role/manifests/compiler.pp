# compiler
class role::compiler {
  include profile::base
  # include puppet::server::puppetdb   # for server config
  include r10k
  include ssh
}
