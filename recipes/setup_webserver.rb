Chef::Log.info("****** Install and starting apache2 web server ******")
service 'apache2' do
  supports :restart => true, :reload => true, :status => true, :enable => true, :reload => true 
  action :install 
end


