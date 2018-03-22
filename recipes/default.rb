include_recipe 'wpmanager::firewall'
include_recipe 'wpmanager::packages'
include_recipe 'wpmanager::nginx'
include_recipe 'wpmanager::wordpress'
include_recipe 'wpmanager::mysql'

# Go cron config
cron 'heartbeat' do
      minute  node[:wp][:alert][:interval]
      command "curl -sm 30 \"#{node[:wp][:alert][:server]}/?cronname=#{node[:hostname]}_gcp_heartbeat&account=#{node[:wp][:alert][:account]}&email=#{node[:wp][:alert][:email]}&frequency=#{node[:wp][:alert][:freq]}&tolerance=0\""
end

# Backup the configs once finished
node[:wp][:sites].each do |site|
      execute "backup #{site}" do
            command "cp #{node[:wp][:root]}/#{site}/wp-config.php /tmp/wp-config.php"
            not_if { File.exists?("/tmp/wp-config.php")}
      end
end

# Remove the default index page
execute "remove default index" do
      command "rm #{node[:wp][:default_index]}"
      only_if { File.exists?("#{node[:wp][:default_index]}")}
end
