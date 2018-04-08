default[:wp][:user] = 'www-data'
default[:wp][:group] = 'www-data'
default[:wp][:root] = "/var/www/html" # NOTE: Dont change without changing the config attribute
default[:wp][:default_index] = "#{node[:wp][:root]}/index.nginx-debian.html"

# List of sites should be overriden with a role.
default[:wp][:sites] = ['wordpress'] # NOTE: Override this

default[:wp][:mysql][:host] = 'localhost'
default[:wp][:mysql][:password] = 'password'  # NOTE: Override this

default[:wp][:packages] = %W[
      ufw
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
      libfcgi-bin
]

default[:wp][:certbot][:packages] = %W[
      certbot
      python-certbot-nginx
]


default[:wp][:service][:web] = 'nginx'
default[:wp][:service][:php] = 'php7.1-fpm'
default[:wp][:service][:db]  = 'mysql'


default[:wp][:nginx_home] = '/etc/nginx'
default[:wp][:conf][:default][:file] = "#{node[:wp][:nginx_home]}/sites-available/default"
default[:wp][:conf][:default][:root] = '/var/www/html;'
default[:wp][:conf][:default][:index] = 'index.php index.html index.htm index.nginx-debian.html;'
default[:wp][:conf][:default][:fastcgi_pass] = 'unix:/var/run/php/php7.1-fpm.sock;'
default[:wp][:conf][:default][:fastcgi_cache_key] = '"$scheme$request_method$host$request_uri";'
default[:wp][:conf][:fastcgi_cache_valid] = "200 60m;"


default[:wp][:amplify][:enable] = false
default[:wp][:amplify][:key] = '' # Override with a role
default[:wp][:amplify][:installer] = '/tmp/amplify.sh'
default[:wp][:amplify][:config][:hostname] = ''
default[:wp][:amplify][:config][:mysqluser] = 'amplify-agent'
default[:wp][:amplify][:config][:mysqlpass] = ''
default[:wp][:amplify][:config][:phpfpm] = 'True'
default[:wp][:amplify][:config][:mysql] = 'True'


default[:wp][:php][:cli][:ini] = '/etc/php/7.1/cli/php.ini'
default[:wp][:php][:fpm][:ini] = '/etc/php/7.1/fpm/php.ini'
