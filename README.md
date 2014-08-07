puppetforge
===========

This script will install puppet forge modules which are specified in puppetforge.modules

Requirements :
=============
Puuppet should be exist on system before running this script
Refer https://cwiki.apache.org/confluence/display/STRATOS/4.0.0+Configuring+Puppet+Master to install puppet master on your system

Usage :
======
./puppetforge.sh -v|-h|--help

h|help => for help
v => to enable verbose mode

Usage of puppetforge.modules
============================

Specify puppetforge modules you want to install on your puppet master.
Don't worry about the dependent modules. Puppt Module Tool will find and download them automatically.

Example 1 :
	puppetlabs-apache
	
	Caution : It will download latest puppetlabs-apache module and all dependent modules to /etc/puppet/modules
	
Example 2 :
	puppetlabs-apache, 1.1.1
	
	Caution : It will download puppetlabs-apache 1.1.1 module and all dependent modules (might be older ones) to /etc/puppet/modules
	  
Recommended way
===============

Don't specify any version unless required. You will be guranteed to have latest modules.
Please note that these versions are not actual software versions. These are puppet module's version.
Hence, it is always better to install latest puppet module.
