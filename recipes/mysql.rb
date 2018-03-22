require 'securerandom'

node[:wp][:sites].each do |site|
      db = site.split(".")[0] # used for db name and username
      pass = SecureRandom.hex
      execute "database_#{site}" do
            user    'root'
            command <<-EOH
                  sudo mysql \
                  --user="root" \
                  --password="#{node[:wp][:mysql][:password]}" \
                  --execute="CREATE DATABASE IF NOT EXISTS #{db}; GRANT ALL PRIVILEGES ON #{db}.* TO #{db} IDENTIFIED BY '#{pass}'; FLUSH PRIVILEGES;"
            EOH
            action :run
            not_if "mysql --user=\"root\" --password=\"#{node[:wp][:mysql][:password]}\" --execute=\"show databases;\" | grep #{db}"
            notifies :restart, "service[mysql]", :delayed
      end

      template "/var/www/html/#{site}/wp-config.php" do
            variables(
                  db: db,
                  dbpass: pass,
                  dbhost: node[:wp][:mysql][:host],
                  auth_key: SecureRandom.hex,
                  secure_auth_key: SecureRandom.hex,
                  logged_in_key: SecureRandom.hex,
                  nonce_key: SecureRandom.hex,
                  auth_salt: SecureRandom.hex,
                  secure_auth_salt: SecureRandom.hex,
                  logged_in_salt: SecureRandom.hex,
                  nonce_salt: SecureRandom.hex
            )
            source 'wp-config.php.erb'
            mode   0664
            not_if { ::File.exists?("/var/www/html/#{site}/wp-config.php")}
      end

end


service 'mysql' do
      action :nothing
end
