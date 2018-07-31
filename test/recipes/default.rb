# all node attributes
node = json("/tmp/kitchen/dna.json").params

# sites list
sites = json("/tmp/kitchen/dna.json").params["wp"]["sites"]
dbpass = json("/tmp/kitchen/dna.json").params["wp"]["mysql"]["password"]

%w[
      git
      vim
      nano
      htop
      nginx
      mysql-server
      software-properties-common
      php7.1
      php7.1-fpm
      php7.1-common
      php7.1-mbstring
      php7.1-xmlrpc
      php7.1-soap php7.1-gd
      php7.1-xml
      php7.1-intl
      php7.1-mysql
      php7.1-cli
      php7.1-mcrypt
      php7.1-ldap
      php7.1-zip
      php7.1-curl
      certbot
      python-certbot-nginx
].each do |pkg|
      describe package pkg do
            it { should be_installed }
      end
end


# Check ports
[22, 80, 443, 3306 ].each do |port|
  describe port port do
    it { should be_listening }
  end
end


%w[ sshd nginx mysql php7.1-fpm ].each do |serv|
      describe systemd_service(serv) do
            it { should be_enabled }
            it { should be_running }
      end
end


# Check the firewall
describe command('ufw status | grep Status') do
      its('stdout') { should eq "Status: active\n" }
      its('exit_status') { should eq 0 }
end

%w[ 22/tcp 80/tcp 443/tcp ].each do |rule|
      describe command("ufw status | grep #{rule}") do
            its('exit_status') { should eq 0 }
      end
end


# Ensure certbot is version 0.21.1 or greater
describe command('certbot --version | grep 0.2') do
      its('stdout') { should eq "certbot 0.25.0\n" }
      its('exit_status') { should eq 0 }
end


# Ensure certbot repo is installed
describe file('/etc/apt/sources.list.d/certbot-ubuntu-certbot-artful.list') do
      it { should be_file }
end


# Ensure sites-available files are present
nginx_avail   = '/etc/nginx/sites-available'
nginx_enabled = '/etc/nginx/sites-enabled'


# Default config
describe file("#{nginx_avail}/default") do
  it { should be_file }
end
describe file("#{nginx_enabled}/default") do
  it { should be_symlink }
  it { should be_linked_to "#{nginx_avail}/default" }
end

# Check each instance site
sites.each do |config|
      describe file("#{nginx_avail}/#{config}") do
            it { should be_file }
      end
end
sites.each do |config|
      describe file("#{nginx_enabled}/#{config}") do
            it { should  be_symlink }
            it { should be_linked_to "#{nginx_avail}/#{config}" }
      end
end



# Parse site config files
["\"index index.php index.html index.htm index.nginx-debian.html;\"",
      "\"fastcgi_pass unix:/var/run/php/php7.1-fpm.sock\"",
      "\"root /var/www/html;\""].each do |match|
      describe command("cat #{nginx_enabled}/default | grep #{match}") do
            its('exit_status') { should eq 0 }
      end
end

sites.each do |site|
      ["\"root /var/www/html/#{site}\"",
      "\"index  index.php index.html index.htm;\"",
      "\"fastcgi_pass unix:/var/run/php/php7.1-fpm.sock\""].each do |match|
            describe command("cat #{nginx_enabled}/#{site} | grep #{match}") do
                  its('exit_status') { should eq 0 }
            end
      end
end




describe file('/tmp/latest.tar.gz') do
      it { should be_file }
end

sites.each do |site|
      describe file("/var/www/html/#{site}") do
            it { should be_directory }
      end
end



# Check for databases and users
sites.each do |site|
      db = site.split(".")[0] # used for database and user
      describe command("sudo mysql --user=\"root\" --password=\"#{dbpass}\" --execute=\"show databases;\" | grep #{db}") do
            its('exit_status') { should eq 0 }
      end
      describe command("sudo mysql --user=\"root\" --password=\"#{dbpass}\" --execute=\"SELECT user FROM mysql.user WHERE user = '#{db}';\" | grep #{db}") do
            its('exit_status') { should eq 0 }
      end
      describe file("/var/www/html/#{site}/wp-config.php") do
            it { should be_file }
      end
end



# Check amplify agent is installed correctly
#describe command('dpkg -s nginx-amplify-agent') do
#      its('exit_status') { should eq 0 }
#end

#if node["wp"]["amplify"]["enable"] == true
#      describe systemd_service('amplify-agent') do
#            it { should be_enabled }
#            it { should be_running }
#      end
#end

#describe command('cat /etc/amplify-agent/agent.conf | grep \'phpfpm = True\'') do
#      its('exit_status') { should eq 0 }
#end
#describe command('cat /etc/amplify-agent/agent.conf | grep \'mysql = True\'') do
#      its('exit_status') { should eq 0 }
#end



# Security tests
describe command('cat /etc/php/7.1/fpm/php.ini | grep \'expose_php = Off\'') do
      its('exit_status') { should eq 0 }
end
describe command('cat /etc/nginx/nginx.conf | grep \'# server_tokens off;\'') do
      its('exit_status') { should eq 1 }
end
describe command('cat /etc/nginx/nginx.conf | grep \'server_tokens off;\'') do
      its('exit_status') { should eq 0 }
end
sites.each do |site|
      describe command("cat /var/www/html/#{site}/.htaccess | grep 'RewriteRule ^readme'") do
            its('exit_status') { should eq 0 }
      end
end


# Validate php config
# Ensure certbot is version 0.21.1 or greater
describe command('cat /etc/php/7.1/cli/php.ini | grep 16M') do
      its('exit_status') { should eq 0 }
end
describe command('cat /etc/php/7.1/fpm/php.ini | grep 16M') do
      its('exit_status') { should eq 0 }
end










#
