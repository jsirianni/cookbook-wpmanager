


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
