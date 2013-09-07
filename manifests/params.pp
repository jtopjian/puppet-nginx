class nginx::params {

  case $::lsbdistid {
    'Ubuntu': {
      $package_name = 'nginx'
      $service_name = 'nginx'
      $user         = 'www-data'
      $conf_dir     = '/etc/nginx'
      $vhost_dir    = '/etc/nginx/sites-enabled'
      $webroot      = '/var/www'
    }
  }

}
