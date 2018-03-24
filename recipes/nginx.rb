template "#{node[:wp][:nginx_home]}/nginx.conf" do
      source 'nginx.conf.erb'
      owner  'root'
      group  'root'
      mode   '0644'
      action :create
      notifies :reload, "service[nginx]", :delayed
end


template node[:wp][:conf][:default][:file] do
  source 'nginx.default.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  action :create
  notifies :reload, "service[nginx]", :delayed
end

link "#{node[:wp][:nginx_home]}/sites-enabled/default" do
  to node[:wp][:conf][:default][:file]
  mode 0777
  notifies :reload, "service[nginx]", :delayed
end

node[:wp][:sites].each do |site|
      template "#{node[:wp][:nginx_home]}/sites-available/#{site}" do
            variables :virtualsite => site
            source 'nginx.virtualhost.erb'
            owner  'root'
            group  'root'
            mode   '0644'
            action :create_if_missing
            notifies :reload, "service[nginx]", :delayed
      end

      link "#{node[:wp][:nginx_home]}/sites-enabled/#{site}" do
            to "#{node[:wp][:nginx_home]}/sites-available/#{site}"
            mode 0777
            notifies :reload, "service[nginx]", :delayed
      end
end


template "#{node[:wp][:nginx_home]}/sites-available/metrics" do
      source 'metrics.erb'
      owner  'root'
      group  'root'
      mode   '0644'
      action :create
      notifies :reload, "service[nginx]", :delayed
end

link "#{node[:wp][:nginx_home]}/sites-enabled/metrics" do
      to "#{node[:wp][:nginx_home]}/sites-available/metrics"
      mode 0777
      notifies :reload, "service[nginx]", :delayed
end


service 'nginx' do
  action :nothing
end
