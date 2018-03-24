execute "add amplify mysql user" do
      user    'root'
      command <<-EOH
            sudo mysql \
            --user="root" \
            --password="#{node[:wp][:mysql][:password]}" \
            --execute="CREATE USER IF NOT EXISTS '#{node[:wp][:amplify][:config][:mysqluser]}' IDENTIFIED BY '#{node[:wp][:amplify][:config][:mysqlpass]}'; FLUSH PRIVILEGES;"
      EOH
      action :run
      not_if "mysql --user=\"root\" --password=\"#{node[:wp][:mysql][:password]}\" --execute=\"SELECT * FROM mysql.user;\" | grep amplify-agent"
      #not_if "mysql --user=\"root\" --password=\"#{node[:wp][:mysql][:password]}\" --execute=\"show databases;\""

end


template "/etc/php/7.1/fpm/pool.d/www.conf" do
      source 'www.conf.erb'
      owner  'root'
      group  'root'
      mode   '0644'
      action :create
      notifies :reload, "service[php7.1-fpm]", "immediately"
end
service 'php7.1-fpm' do
      action :nothing
end

remote_file node[:wp][:amplify][:installer] do
  source 'https://github.com/nginxinc/nginx-amplify-agent/raw/master/packages/install.sh'
  mode '0755'
  action :create
  notifies :run, "execute[install_amplify]", :immediately
end

execute 'install_amplify' do
  command "API_KEY='#{node[:wp][:amplify][:key]}' #{node[:wp][:amplify][:installer]}"
  action :nothing
end

template "/etc/amplify-agent/agent.conf" do
      variables(
            pass: node[:wp][:amplify][:config][:mysqluser]
      )
      source 'agent.conf.erb'
      owner  node[:wp][:user]
      group  node[:wp][:group]
      mode   '0644'
      action :create
      if node[:wp][:amplify][:enable] == true
            notifies :restart, "service[amplify-agent]", "immediately"
      end
end

service 'amplify-agent' do
  if node[:wp][:amplify][:enable] == true
    action [:start, :enable]
  else
    action [:stop, :disable]
  end
end
