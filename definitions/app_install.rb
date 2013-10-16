define :mezzanine_app, :git_repository => nil, :git_revision => 'HEAD', :port => 8000, :hostname => nil do

  if not node['gunicorn']
    Chef::Application.fatal!("mezzanine requires gunicorn")
  end

  app = params[:name]

  virtualenv_dir = node['gunicorn']['virtualenv'] # Virtualenv is created by "gunicorn" cookbook
  python_bin = "#{virtualenv_dir}/bin/python"
  app_dir = "#{virtualenv_dir}/app/#{app}"
  svc = "mezzanine-#{app}"

  Chef::Log.info("Setting up mezzanine_app #{app}")
  if not params[:git_repository]
    Chef::Application.fatal!("mezzanine_app did not get :git_repository argument")
  end

  git app_dir do
    action :sync
    repository params[:git_repository]
    revision params[:git_revision]
  end

  execute "Collect static files for project at #{app_dir}" do
    cwd app_dir
    command "#{python_bin} manage.py collectstatic --noinput"
    creates "#{app_dir}/static"
  end

  template "#{node['nginx']['dir']}/sites-available/#{svc}" do
    cookbook "mezzanine"
    source "nginx-mezzanine.erb"
    variables ({
      :app => app,
      :app_dir => app_dir,
      :port => params[:port],
      :hostname => params[:hostname]
    })
    notifies :reload, "service[nginx]"
  end

  nginx_site svc

  runit_service svc do
    cookbook "mezzanine"
    run_template_name "mezzanine"
    options ({
      :app_name => app,
      :port => params[:port],
      :virtualenv_dir => virtualenv_dir,
    })
    default_logger true
  end

  if not node['mezzanine']['apps']
    node['mezzanine']['apps'] = []
  end

  if not node['mezzanine']['apps'].include?(app)
    node['mezzanine']['apps'] << app
  end

end
