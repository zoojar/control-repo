Facter.add('powerstates') do
  confine kernel: 'Linux'
  cmd = 'echo toml-rb_installed=`/opt/puppetlabs/bin/puppetserver gem list toml-rb -i`'
  setcode do
    Facter::Core::Execution.execute(cmd)
  end
end