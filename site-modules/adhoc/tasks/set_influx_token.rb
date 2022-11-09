#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
params = JSON.parse(STDIN.read)
content = File.write('/opt/puppetlabs/facter/facts.d/telegraf_agent_token.txt', params['token'])
