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
class mule (
  $url       = 'https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/3.7.0/mule-standalone-3.7.0.tar.gz',
  $user      = 'mule',
  $group     = 'mule',
  $basedir   = '/usr/local',
  $subdir    = 'mule',
  $java_home = '/usr/bin/java',
) {
  
  $mule_home = "${basedir}/${subdir}"

  archive { $mule_home:
    ensure => present,
    url    => $url,
    target => $basedir,
  }

  user { $user: 
    managehome => true,
  } ->

  file { "/home/${user}/.profile":
    content => template('.profile.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0644',
  }

}
