package node[:wp][:packages] do
      action :install
end


execute 'install_certbot_ppa' do
      user    'root'
      command 'add-apt-repository ppa:certbot/certbot -y; apt-get update'
      not_if  { ::File.exists?('/etc/apt/sources.list.d/certbot-ubuntu-certbot-artful.list') }
end


package node[:wp][:certbot][:packages] do
      action :nothing
      subscribes :upgrade, 'execute[install_certbot_ppa]', :immediately
end


[ node[:wp][:service][:web], node[:wp][:service][:php], node[:wp][:service][:db] ].each do |s|
      service s do
            action [ :enable, :start ]
      end
end
