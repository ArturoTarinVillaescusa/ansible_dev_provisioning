require 'yaml'
nodes_config = (YAML.load(File.read("nodes.yaml")))['nodes']
id_rsa_ssh_key_pub = File.read(File.join(Dir.home, ".ssh", "id_rsa.pub"))
vagrant_root = File.dirname(__FILE__)
Vagrant.configure(2) do |config|

  nodes_config.each do |node|
    node_name   = node[0] # name of node
    node_values = node[1] # content of node

    config.vm.define node_name do |config|
      config.vm.box =  node_values[':box']
      #config.ssh.insert_key = false
      #config.ssh.private_key_path = [ '~/.ssh/id_rsa' ]
      config.ssh.forward_agent = true
      # configures all forwarding ports in JSON array
      #ports = node_values['ports']
      #ports.each do |port|
      #  config.vm.network :forwarded_port,
      #    host:  port[':host'],
      #    guest: port[':guest']
      #end

      #config.vm.hostname = node_name[/(.*?)\./]
      config.vm.hostname = node_values[':name']
      config.vm.network :private_network, ip: node_values[':ip']

      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", node_values[':memory']]
        vb.customize ["modifyvm", :id, "--name", node_name]
        vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ['modifyvm', :id, '--natnet1', '192.168.222.0/24']
      end

      config.vm.provision "shell", inline: <<-SHELL
        echo "Copying local id_rsa SSH Key to VM auth_keys for auth purposes (login into VM included)..."
        echo '#{id_rsa_ssh_key_pub}' > /home/vagrant/.ssh/authorized_keys
        chmod 600 /home/vagrant/.ssh/authorized_keys
      SHELL

    end
  end
end
