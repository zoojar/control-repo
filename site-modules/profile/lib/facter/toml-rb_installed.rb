Facter.add('toml-rb_installed') do
  confine kernel: 'Linux'
  setcode do
    Facter::Core::Execution.execute('/opt/puppetlabs/bin/puppetserver gem list toml-rb -i')
  end
end