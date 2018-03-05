#!/bin/bash
curl -L https://www.opscode.com/chef/install.sh | sudo bash
mkdir ~/.chef
echo "cookbook_path '$HOME'" > $HOME/.chef/knife.rb
echo "cookbook_path '$HOME'" > $HOME/solo.rb
echo "{\"wp\":{\"sites\":[\"example.com\",\"example2.com\"]},\"run_list\":[\"recipe[wpmanager::default]\"]}" > dna.json
nano dna.json
sudo chef-solo -c cookbook-wpmanager/solo.rb -j cookbook-wpmanager/dna.json
