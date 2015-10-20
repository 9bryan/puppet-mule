# == Class: mule
#
# This module allows you to define and install multiple instances of MuleSoft ESB community.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Authors
#
# Bryan Wood <bryan.wood@puppetlabs.com>
#
# === Copyright
#
# Copyright 2015 Bryan Wood, unless otherwise noted.
#
define mule (
  $download_base_url = 'https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/3.7.0',
  $filename          = 'mule-standalone-3.7.0.tar.gz',
  $user              = $title,
  $group             = $title,
  $basedir           = '/usr/local',
  $subdir            = $title,
  $java_home         = '/usr/bin/java',
  $service_name      = $title,
) {
  $mule_home = "${basedir}/${subdir}"

  user { $user:
    ensure     => present,
    managehome => true,
  } ->

  file { $mule_home:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  } ->

  staging::file { "${title}-${filename}":
    source => "${download_base_url}/${filename}",
  }

  #Extract Hadoop media to $hadoop_home
  staging::extract { "${title}-${filename}":
    source  => "/opt/staging/mule/${title}-${filename}",
    target  => $mule_home,
    user    => $user,
    group   => $user,
    strip   => 1,
    creates => "${mule_home}/bin",
    require => [File[$mule_home],Staging::File["${title}-${filename}"]],
  }

  file { "/home/${user}/.profile":
    ensure  => file,
    content => template('mule/profile.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0644',
    require => User[$user],
  }

  file { "/etc/init.d/${service_name}":
    ensure  => file,
    content => template('mule/mule.init.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  service { $service_name:
    ensure  => running,
    enable  => true,
    require => [ File["/etc/init.d/${service_name}"], Staging::Extract["${title}-${filename}"] ]
  }

}
