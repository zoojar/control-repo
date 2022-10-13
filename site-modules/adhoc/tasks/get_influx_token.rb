#!/opt/puppetlabs/puppet/bin/ruby
content = File.read('/etc/systemd/system/telegraf.service.d/override.conf')
puts content.split('Environment="INFLUX_TOKEN=')[1].gsub('"','')
