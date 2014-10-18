# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'global-links'
  config.vm.box = "ubuntu/trusty64"

  config.vm.network :forwarded_port, guest: 9292, host: 9292, auto_correct: true
  config.vm.provision :shell, path: '.vagrant-provision.sh'
  config.vm.define 'global-links' do |host|
  end
end
