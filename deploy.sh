#!/bin/bash
sudo apt-get update && sudo apt-get install mysql-server
sudo mysql_secure_installation
curl -L https://www.opscode.com/chef/install.sh | sudo bash
mkdir ~/.chef
echo "cookbook_path '$HOME'" > $HOME/.chef/knife.rb
echo "cookbook_path '$HOME'" > $HOME/solo.rb
echo "{\"wp\":{\"sites\":[\"example.com\",\"example2.com\"]},\"run_list\":[\"recipe[wpmanager::default]\"]}" > dna.json
nano dna.json
sudo chef-solo -c solo.rb -j dna.json
