define :mirror, :web_app_template => nil,
                :task_template => "mirror_task.conf.erb",
                :shim_template => "mirror_shim.conf.erb" do
  mirror_name    = params[:name]
  mirror_user    = params[:user]
  
  directory params[:target] do
    owner mirror_user
    group mirror_user
    mode "0755"
    recursive true
  end
  
  {
    params[:task_template] => "/etc/init/#{mirror_name}_mirror.conf",
    params[:shim_template] => "/etc/init/#{mirror_name}_mirror_shim.conf",
  }.each do |src, target|
    template target do
      source src
      owner mirror_user
      group mirror_user
      mode "0644"
      variables(
        :params => params
      )
      if params[:cookbook]
        cookbook params[:cookbook]
      end
    end
  end

  service "#{mirror_name}_mirror_shim" do
    provider Chef::Provider::Service::Upstart
    action :nothing
  end
  
  # HACK: Definitions have a local-scope `params`, so use a different name
  p = params
  # Serve the mirror
  web_app "#{mirror_name}_mirror" do
    docroot p[:target]
    hostname p[:hostname]
    port p[:port]
    if p[:cookbook]
      cookbook p[:cookbook]
    end
    if p[:web_app_template]
      template p[:web_app_template]
    end
  end
  
  log "Scheduling #{mirror_name} mirroring; `sudo tail -f /var/log/upstart/#{mirror_name}_mirror.log` to monitor." do
    notifies :restart, "service[#{mirror_name}_mirror_shim]"
  end
end