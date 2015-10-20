# mule

#### Table of Contents

1. [Overview](#overview)
3. [Setup - The basics of getting started with mule](#setup)
    * [What mule affects](#what-mule-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mule](#beginning-with-mule)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages multiple concurrent instances of MuleSoft ESB.

## Setup

### What mule affects

* This module pulls down a tarball of the installation media and stores it in /tmp 
* Mulesoft requires Java and you should make sure to include java installation (Preferably with the puppetlabs-java module) in your profile.
* Creates user, init script, and mule_home for each instance.

### Setup Requirements

Java

## Usage

### Install Mule community edition and register it as service mule1, dont forget java
```puppet
include java
mule { 'mule1': }
```

### More advanced configuration
```puppet
include java
mule { 'mule1': 
  url     => 'https://custom/location/filename.tar.gz',
  basedir => '/opt',
  service_name => 'CustomServiceName',
}
```

## Limitations

Currently only tested with PE 2015.2 on RHEL 6

## Development

Please feel free to file a pull request if you notice something you would like to change!
