node[:wp][:packages] = %W[
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
      php7.1-mysqli
      php7.1-cli
      php7.1-mcrypt
      php7.1-ldap
      php7.1-zip
      php7.1-curl
]

node[:wp][:certbot][:packages] = %W[
      certbot
      python-certbot-nginx
]


node[:wp][:service][:web] = 'nginx'
node[:wp][:service][:php] = 'php7.1-fpm'
node[:wp][:service][:db]  = 'mysql'
