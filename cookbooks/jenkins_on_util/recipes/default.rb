if @node[:instance_role] == 'util' and @node[:name].match(/jenkins/) then
  include_recipe "jenkins_on_util::jetty_install"
  include_recipe "jenkins_on_util::jenkins_install"

end

if ['app_master','solo'].include? @node[:instance_role] then
  template "/etc/nginx/servers/jetty.conf" do
    owner 'root'
    group 'root'
    mode 600
    source "nginx.jetty.conf.erb"
    variables({
      host: @node[:utility_instances].keep_if{|server| server['name'] =~ /jenkins/}.first['hostname'],
      public_host: @node[:jenkins][:public_host]
      })
  end 

  execute "reload-nginx" do
    action :nothing
    command "/etc/init.d/nginx reload"
  end
end
