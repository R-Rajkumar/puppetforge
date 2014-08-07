#!/bin/bash
#This script will install puppet forge modules to /etc/puppet/modules
#If you specify any version for a module, you have to specify dependencies too
#If you don't specify any version for a module, all dependencies of that #module will be installed automatically.

ECHO=`which echo`
function print_usage(){
    ${ECHO} -e "Puppet Module Tool Installer v1 2014-02-12"
    ${ECHO} -e "This script will install Puppet Module Tool and download all the puppetforge modules specified in modules.txt"
    ${ECHO} -e ""
    ${ECHO} -e "Requirements: "
    ${ECHO} -e "Puppet Master should be installed before running this script"
    ${ECHO} -e ""
    ${ECHO} -e "Usage: "
    ${ECHO} -e " sh puppetforge"
    ${ECHO} -e " If you want specific versions of modules, you can specify a version for each modules in moduls.txt"
    ${ECHO} -e " If you specify versions, dependency modules will not be downloaded automatically, you have to specify all dependency modules and versions in modules.txt"
    ${ECHO} -e " If you don't specify any versions, puppet module tool will find all the dependencies and download them automatically"
    ${ECHO} -e ""
}

function check_for_puppet(){
# Checking for puppet
    print_message "Checking for puppet installations ... "
    if [[ -d '/var/lib/puppet' ]]; then
print_ok
    else
print_error "You should install puppet master before running this script"
 exit 1
    fi
}
check_for_puppet
print_usage
INPUT=modules
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read module version
do
	if [[ -n $version ]]; then
        puppet module install $module --version $version
	else
	puppet module install $module
done < $INPUT
IFS=$OLDIFS



