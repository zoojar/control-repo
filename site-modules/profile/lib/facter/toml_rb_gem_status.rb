Facter.add(:toml_rb_gem_status) do
  confine kernel: 'Linux'

  setcode do
    { gem_installed: !Dir.glob('/opt/puppetlabs/server/data/puppetserver/jruby-gems/gems/toml-rb-*').empty? }
  end
end
