define :mezzanine_app, :git_repository => nil, :git_revision => 'HEAD', :port => 8000, :hostname => nil do
  if node['mezzanine']['apps']

    if not node['gunicorn']
      Chef::Application.fatal!("mezzanine requires gunicorn")
    end

    app = params[:name]

    virtualenv_dir = node['gunicorn']['virtualenv'] # Virtualenv is created by "gunicorn" cookbook
    python_bin = "#{virtualenv_dir}/bin/python"
    app_dir = "#{virtualenv_dir}/app/#{app}"

    template "#{app_dir}/local_settings.py" do
      cookbook "mezzanine"
      source "mezzanine-local_settings.py.erb"
      variables :app_dir => app_dir
    end

    execute "Create DB for project at #{app_dir}" do
      cwd app_dir
      command "#{python_bin} manage.py createdb --noinput --nodata"
      creates "#{app_dir}/dev.db"
    end
  else
    Chef::Log.warn("mezzanine::configure_db - no mezzanine apps found")
  end
end
