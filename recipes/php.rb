template node[:wp][:php][:fpm][:ini] do
      source 'php.ini.erb'
      owner  'root'
      group  'root'
      mode   '0644'
      action :create
      notifies :reload, "service[php7.1-fpm]", :delayed
end

template node[:wp][:php][:cli][:ini] do
      source 'php.ini.cli.erb'
      owner  'root'
      group  'root'
      mode   '0644'
      action :create
      notifies :reload, "service[php7.1-fpm]", :delayed
end

service 'php7.1-fpm' do
  action :nothing
end
