class nginx::server (
  $package_ensure   = 'latest',
  $service_enable   = true,
  $user             = $::nginx::params::user,
  $conf_dir         = $::nginx::params::conf_dir,
  $vhost_dir        = $::nginx::params::vhost_dir,
  $threadcount      = $::processorcount,
  $hash_bucket_size = 32,
) inherits nginx::params {

  package { 'nginx':
    name   => $::nginx::params::package_name,
    ensure => $package_ensure,
  }

  if $service_enable {
    $service_ensure = 'running'
  } else {
    $service_ensure = 'stopped'
  }

  service { 'nginx':
    name      => $::nginx::params::service_name,
    ensure    => $service_ensure,
    enable    => $service_enable,
    subscribe => Package['nginx'],
  }

  File {
    notify  => Service['nginx'],
    require => Package['nginx'],
  }

  file {
    $vhost_dir:
      ensure  => directory,
      recurse => true,
      purge   => true;
    "${conf_dir}/nginx.conf":
      ensure  => present,
      content => template('nginx/nginx.conf.erb'),
      owner   => 'root',
      mode    => '0640';
  }

}
