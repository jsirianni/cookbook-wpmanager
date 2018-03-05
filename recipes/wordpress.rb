# Get the latest wordpress
remote_file "/tmp/latest.tar.gz" do
      source 'https://wordpress.org/latest.tar.gz'
      mode '0755'
      action :create
end

node[:wp][:sites].each do |site|
      execute 'deploy wordpress' do
            command <<-EOH
                  tar -zxf /tmp/latest.tar.gz -C /var/www/html/
                  mv /var/www/html/wordpress /var/www/html/#{site}
            EOH
            notifies :run, "execute[chown]", :delayed
            not_if { ::Dir.exists?("/var/www/html/#{site}") }
      end
end

execute 'chown' do
      command "chown -R #{node[:wp][:user]}:#{node[:wp][:goup]} /var/www/html"
      action :nothing
end
