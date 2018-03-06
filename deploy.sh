#!/bin/bash
# Must run mysql_secure_installation before running this script

curl -L https://www.opscode.com/chef/install.sh | sudo bash
mkdir ~/.chef
echo "cookbook_path '$HOME'" > $HOME/.chef/knife.rb
echo "cookbook_path '$HOME'" > $HOME/solo.rb
echo "{\"wp\":{\"sites\":[\"example.com\",\"example2.com\"],\"mysql\":{\"password\": \"password\"},\"alert\"{\"server\": \"\", \"account\":\"\", \"email\":\"\"}},\"run_list\":[\"recipe[wpmanager::default]\"]}" > dna.json
nano dna.json
clear
echo "make sure dna.json includes your database root password"
echo "Run: 'sudo chef-solo -c solo.rb -j dna.json'"
