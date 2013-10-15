define :mezzanine_app_start, :git_repository => nil, :git_revision => 'HEAD', :port => 8000, :hostname => nil do
  app = params[:name]
  service "mezzanine-#{app}" do
    action :start
  end
end
