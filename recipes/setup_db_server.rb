include_recipe "apt" # Otherwise apt packages install can fail because of stale apt cache
include_recipe "postgresql::server"
