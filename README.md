puppetforge
===========

This script will install puppet forge modules which are specified in puppetforge.modules

Requirements :
Puuppet should be exist on system before running this script
Refer https://cwiki.apache.org/confluence/display/STRATOS/4.0.0+Configuring+Puppet+Master to install puppet master on your system

Usage :
./puppetforge.sh -v|-h|--help

h|help => for help
v => to enable verbose mode

Usage of puppetforge.modules
============================

Specify puppetforge modules you want to install on your puppet master

Example 1 :
	puppetlabs-apache
	
	Caution : It will download latest puppetlabs-apache module and all dependent modules to /etc/puppet/modules
	
Example 2 :
	puppetlabs-apache, 1.1.1
	
	Caution : It will download puppetlabs-apache 1.1.1 module and all dependent modules to /etc/puppet/modules
			  It works because latest puppetlabs-apache version is 1.1.1
			  
Example 3 :
	puppetlabs-apache, 0.2.1
	
	Caution : It will only download puppetlabs-apache 1.0.1 module to /etc/puppet/modules
			  You have to list dependent modules in puppetforge.modules explicitly as below,
			  
Recommended way
===============

Don't specify any version unless required.

If you specify any version to one module, do so for all modules. Because it is not guranteed that it will download dependent modules if you specify an older version of a module.
			




