# Assumes: Postgresql is already installed

# TODO: fix: CREATE DATABASE can fail silently (fails when exists)

define :mezzanine_db_create_database do
  Chef::Application.fatal!("mezzanine::mezzanine_db_create_database expects Postgresql to be installed") unless node['postgresql']
  app = params[:name]
  db_name = "mezzanine_#{app}"
  bash "create-postgres-database-#{db_name}" do
    user 'postgres'
    code <<-EOH
      echo 'CREATE DATABASE "#{db_name}";' | psql
    EOH
    action :run
  end

  if not node['mezzanine_databases']
    node.set['mezzanine_databases'] = []
  end

  node.set['mezzanine_databases'] << db_name

end
