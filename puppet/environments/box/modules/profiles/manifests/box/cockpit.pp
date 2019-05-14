class profiles::box::cockpit {

  package { 'cockpit': }

  ini_setting { 'Cockpit LoginTitle':
    ensure    => present,
    path      => '/etc/cockpit/cockpit.conf',
    section   => 'WebService',
    setting   => 'LoginTitle',
    value     => $::fqdn,
    show_diff => true,
    require => Package['cockpit'],
    notify => Service['cockpit']
  }

  ini_setting { 'Cockpit MaxStartups':
    ensure    => present,
    path      => '/etc/cockpit/cockpit.conf',
    section   => 'WebService',
    setting   => 'MaxStartups',
    value     => 10,
    show_diff => true,
    require => Package['cockpit'],
    notify => Service['cockpit']
  }

  ini_setting { 'Cockpit AllowUnencrypted':
    ensure    => present,
    path      => '/etc/cockpit/cockpit.conf',
    section   => 'WebService',
    setting   => 'AllowUnencrypted',
    value     => true,
    show_diff => true,
    require => Package['cockpit'],
    notify => Service['cockpit']
  }

  service { 'cockpit':
    ensure => 'running',
    enable => true,
    require => Package['cockpit']
  }
}