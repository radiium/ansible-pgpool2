# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
require_relative './tools/key_authorization'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = true
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  authorize_key_for_root config, '~/.ssh/id_rsa.pub'


  config.vm.define 'postgres-1' do |machine|
    machine.vm.hostname = 'postgres-1'
    machine.vm.network "private_network", ip: "192.168.33.42"
  end
  config.vm.define 'postgres-2' do |machine|
    machine.vm.hostname = 'postgres-2'
    machine.vm.network "private_network", ip: "192.168.33.43"
  end





#  config.vm.provision :ansible do |ansible|
#    ansible.playbook = "all.yml"
#    ansible.limit = "all"
#    ansible.sudo = true
#    ansible.groups = { 
#      "postgres" => ["postgres-1", "postgres-2"],
#    }
#  end
end
