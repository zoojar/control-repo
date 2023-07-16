# compiler
class role::compiler {
  include profile::base
  # include puppet::server::puppetdb   # for server config
  include r10k
  include r10k::mcollective
  include ssh
  include mcollective   # choria for r10k deploys
} 
