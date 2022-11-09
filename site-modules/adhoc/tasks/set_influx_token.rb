#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
params = JSON.parse(STDIN.read)
content = File.write('/opt/puppetlabs/facter/facts.d/telegraf_agent_token.txt', "telegraf_agent_token=#{params['token']}")
