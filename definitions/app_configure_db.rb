define :mezzanine_app_configure_db, :git_repository => nil, :git_revision => 'HEAD', :port => 8000, :hostname => nil do

  if not node['gunicorn']
    Chef::Application.fatal!("mezzanine requires gunicorn")
  end

  if not node['injected'] or not node['injected']['mezzanine_db_host']
    Chef::Application.fatal!("mezzanine database configuration requires attribute injected.mezzanine_db_host")
  end

  app = params[:name]

  db_host = node['injected']['mezzanine_db_host']
  dbs = search(:node, "ipaddress:#{db_host}")

  virtualenv_dir = node['gunicorn']['virtualenv'] # Virtualenv is created by "gunicorn" cookbook
  app_dir = "#{virtualenv_dir}/app/#{app}"
  python_bin = "#{virtualenv_dir}/bin/python"

  if dbs.length == 0
    Chef::Application.fatal!("mezzanine database configuration failed to find Chef node with ipaddress #{db_host}")
  end

  if dbs.length > 1
    Chef::Application.fatal!("mezzanine database configuration found more than one Chef node with ipaddress #{db_host}")
  end

  db_node = dbs.first
  Chef::Log.info("Using node #{db_node} as mezzanine database host. The node was found by injected address #{db_host}")

  virtualenv_dir = node['gunicorn']['virtualenv'] # Virtualenv is created by "gunicorn" cookbook
  python_bin = "#{virtualenv_dir}/bin/python"
  app_dir = "#{virtualenv_dir}/app/#{app}"

  template "#{app_dir}/local_settings.py" do
    cookbook "mezzanine"
    source "mezzanine-local_settings.py.erb"
    variables ({
      :app     => app,
      :app_dir => app_dir,
      :db_host => db_host,
      :db_node => db_node,
    })
  end

  execute "Create DB for project at #{app_dir}" do
    cwd app_dir
    command "#{python_bin} manage.py createdb --noinput --nodata"
    not_if do
      # Not if we have something in the DB
      puts "Checking DB, please ignore 'Unable to serialize database' if it follows this message"
      `cd #{app_dir} && #{python_bin} manage.py dumpdata --format json`.include?('"pk"')
    end
  end
end
