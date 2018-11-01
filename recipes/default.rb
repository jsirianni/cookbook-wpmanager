include_recipe 'wpmanager::firewall'
include_recipe 'wpmanager::packages'
include_recipe 'wpmanager::php'
include_recipe 'wpmanager::nginx'
include_recipe 'wpmanager::wordpress'
include_recipe 'wpmanager::mysql'



node[:wp][:sites].each do |site|
      # Backup the configs once finished
      execute "backup #{site}" do
            command "cp #{node[:wp][:root]}/#{site}/wp-config.php /tmp/#{site}.wp-config.php"
            not_if { File.exists?("/tmp/#{site}.wp-config.php")}
      end
end

# Remove the default index page
execute "remove default index" do
      command "rm #{node[:wp][:default_index]}"
      only_if { File.exists?("#{node[:wp][:default_index]}")}
end
