class profiles::php {

  include ::php
  include ::php::dev

  include ::profiles::php::composer
  include ::profiles::systemd::reload

  $version = hiera('php::globals::php_version', '7.1')

  file { '/opt/php/':
    ensure => directory
  }
  ->
  file { '/opt/php/php-fpm.sock':
    ensure => link,
    target => '/run/php/php7.1-fpm.sock',
    notify => Service['httpd']
  }

  ::apache::custom_config { 'php-fpm':
    source  => 'puppet:///modules/profiles/php/apache.conf',
    verify_config => false
  }

  exec { 'pecl-alternative':
    command => "mv /usr/bin/pecl /usr/bin/pecl${version} && /usr/bin/update-alternatives --install /usr/bin/pecl pecl /usr/bin/pecl${version} 70",
    unless  => "/usr/bin/test -h /usr/bin/pecl",
    require => Anchor['php::end']
  }

  exec { 'pear-alternative':
    command => "mv /usr/bin/pear /usr/bin/pear${version} && /usr/bin/update-alternatives --install /usr/bin/pear pear /usr/bin/pear${version} 70",
    unless  => "/usr/bin/test -h /usr/bin/pear",
    require => Anchor['php::end']
  }

  exec { 'php-fpm-alternative':
    command => "/usr/bin/update-alternatives --install /usr/sbin/php-fpm php-fpm /usr/sbin/php-fpm${version} 70",
    unless  => "/usr/bin/test -h /usr/sbin/php-fpm",
    require => Anchor['php::end']
  }

  file { '/lib/systemd/system/php-fpm.service':
    ensure => present,
    source => 'puppet:///modules/profiles/php/php-fpm.service',
    notify => [Class['::profiles::systemd::reload'], Service['php-fpm']]
  }

  file { '/usr/lib/tmpfiles.d/php-fpm.conf':
    ensure  => file,
    content => 'd /run/php/ 0755 - - -',
    notify  => [Class['::profiles::systemd::reload'], Service['php-fpm']]
  }

  file { '/run/php':
    ensure => directory,
    mode   => '0755',
    notify => Service['php-fpm']
  }

  ini_setting { 'php-fpm-no-daemonize':
    ensure  => present,
    value   => 'no',
    path    => "/etc/php/${version}/fpm/php-fpm.conf",
    section => 'global',
    setting => 'daemonize',
    require => Anchor['php::end'],
    notify  => Service['php-fpm']
  }

  service { 'php-fpm':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    enable     => true,
    require    => [Class['::profiles::systemd::reload'], Anchor['php::end']]
  }

  ::php::config { 'php.ini-template':
    file   => '/home/vagrant/php.ini-template',
    config => hiera('php::settings', {})
  }

  # Disable Xdebug by default
  file { "/etc/php/${version}/mods-available/xdebug.ini":
      ensure  => file,
      content => '; zend_extension=xdebug.so',
      require => Anchor['php::end']
  }

}