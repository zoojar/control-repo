Facter.add(:toml_rb_gem_status) do
  confine kernel: 'Linux'
  cmd = '/opt/puppetlabs/bin/puppetserver gem list toml-rb -i'
  setcode do
    { gem_installed: Facter::Core::Execution.execute(cmd).tr('\"', '') }
  end
end
