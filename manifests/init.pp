# == Class: mule
#
# Full description of class mule here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'mule':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
define mule (
  $url          = 'https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/3.7.0/mule-standalone-3.7.0.tar.gz',
  $archive      = 'mule-standalone-3.7.0.tar.gz',
  $user         = $title,
  $group        = $title,
  $basedir      = '/usr/local',
  $subdir       = $title,
  $java_home    = '/usr/bin/java',
  $service_name = $title,
) {
   
  $mule_home = "${basedir}/${subdir}"
  include 'archive'

  user { $user:
    managehome => true,
  }

  file { $mule_home:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }

  archive { "/tmp/${archive}":
    source       => $url,
    extract      => true,
    cleanup      => true,
    extract_path => $mule_home,
    user         => $user,
    group        => $group,
  }

  file { "/home/${user}/.profile":
    ensure  => file,
    content => template('mule/profile.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0644',
  }

  file { "/etc/init.d/${service_name}":
    ensure  => file,
    content => template('mule/mule.init.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

}
