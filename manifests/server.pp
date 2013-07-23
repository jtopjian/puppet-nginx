class nginx::server (
  $threadcount      = hiera('nginx_threadcount'),
  $user             = hiera('nginx_user'),
  $hash_bucket_size = hiera('nginx_hash_bucket_size'),
  $etcdir           = hiera('nginx_etcdir'),
  $vdir             = hiera('nginx_vdir'),
) {

  package { 'nginx':
    ensure => hiera('nginx_package_ensure'),
    name   => hiera('nginx_package'),
  }

  $service_ensure = hiera('nginx_service_ensure')
  if ($service_ensure == 'running') {
    $service_enable = true
  } else {
    $service_enable = false
  }
  service { 'nginx':
    ensure    => hiera('nginx_service_ensure'),
    enable    => $service_enable,
    subscribe => Package['nginx'],
  }

  File {
    notify  => Service['nginx'],
    require => Package['nginx'],
  }

  file {
    $vdir:
      ensure  => directory,
      recurse => true,
      purge   => true;
    "${etcdir}/nginx.conf":
      ensure  => present,
      content => template('nginx/nginx.conf.erb'),
      owner   => 'root',
      mode    => '0640';
  }

}
