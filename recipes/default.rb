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
