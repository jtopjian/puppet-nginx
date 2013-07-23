# Define: nginx::server::vhost
#
#   Deploy an nginx vhost configuration file.
#
# Parameters:
#
define nginx::vhost (
  $port             = '80',
  $priority         = '10',
  $template         = 'nginx/vhost-default.conf.erb',
  $servername       = '',
  $ssl              = false,
  $sslonly          = false,
  $ssl_port         = '443',
  $ssl_path         = undef,
  $ssl_cert         = undef,
  $ssl_key          = undef,
  $magic            = '',
  $serveraliases    = undef,
  $template_options = {},
  $isdefaultvhost   = false,
  $vhostroot        = '',
  $autoindex        = false,
  $webroot          = '/var/www',
) {

  # Determine the name of the vhost
  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  # Determine the location to put the root of this vhost
  if $vhostroot == '' {
    $docroot = "${webroot}/${srvname}"
  } else {
    $docroot = $vhostroot
  }

  # Write the nginx configuration
  $vdir = hiera('nginx_vdir')
  file { "${vdir}/${priority}-${name}":
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

}
