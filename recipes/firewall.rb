execute 'enable firewall' do
      command 'ufw enable'
      not_if 'ufw status | grep "Status: active"'
end

execute 'allow ports' do
      command 'ufw allow ssh'
      not_if 'ufw status | grep 22/tcp'
end

execute 'allow ports' do
      command 'ufw allow http'
      not_if 'ufw status | grep 80/tcp'
end

execute 'allow ports' do
      command 'ufw allow https'
      not_if 'ufw status | grep 443/tcp'
end
