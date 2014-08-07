#!/bin/bash
 
# Puppetforge Module Installer.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This script will install puppet forge modules to /etc/puppet/modules
# It will read the modules from modules file.
# If you specify any version for a module, you have to specify dependencies
# too. For example, if you want to install a specific version of apache,
# you would modify your puppetforge.modules file as below,
#	puppetlabs-apache, 1.1.1
#	puppetlabs-stdlib, 2.4.0
#	puppetlabs-concat, 1.0.0

# On the otherhand, if you don't specify any version for a module, 
# it will download the latest version with all dependencies of that module 
# automatically
# For example, if you want to install the latest version of apache module,
# you would modify your puppetforge.modules file as below,
#	puppetlabs-apche
# Puppet Module Tool will find right dependencies and install them for you.

set -e

# General commands
ECHO=`which echo`

# Parameters
VERBOSE=0

# Execute bashtrap function when user press [Ctrl]+[c]
trap bashtrap INT

function print_usage(){
    ${ECHO} -e "Puppetforge Module Installer v1 2014-02-12"
    ${ECHO} -e ""	
    ${ECHO} -e "This script will download all the puppetforge modules which"
    ${ECHO} -e "are specified in the puppetforge.modules"
    ${ECHO} -e ""
    ${ECHO} -e "Requirements: "
    ${ECHO} -e " Puppet Master should be installed before running this script"
    ${ECHO} -e " Refer https://cwiki.apache.org/confluence/display/STRATOS/4.0.0+Configuring+Puppet+Master"
    ${ECHO} -e ""
    ${ECHO} -e "Usage: "
    ${ECHO} -e " bash puppetforge"
    ${ECHO} -e " If you want specific versions of modules, "
    ${ECHO} -e " you can specify a version for each modules in puppetforge.modules"
    ${ECHO} -e ""    
    ${ECHO} -e " If you specify versions, dependency modules will not be downloaded automatically, "
    ${ECHO} -e " you have to specify all dependency modules and versions in puppetforge.modules"
    ${ECHO} -e ""
    ${ECHO} -e " If you don't specify any versions, puppet module tool "
    ${ECHO} -e " will downlaod latest version with all the dependencies automatically"
    ${ECHO} -e ""
}

function print_message(){
    if [ ${VERBOSE} -eq 1 ]; then
        ${ECHO} -en $1
    fi
}

function print_ok(){
    if [ ${VERBOSE} -eq 1 ]; then
        ${ECHO} -e " [Done]"
    fi
}

function print_error(){
    if [ ${VERBOSE} -eq 1 ]; then
        ${ECHO} -e " [Error]\n"$1
    else
        ${ECHO} -e "[Error]" $1
    fi
exit 1
}

function check_for_puppet(){
# Checking for puppet
    print_message "Checking for puppet installtion ... "
    if [[ -d '/var/lib/puppet' ]]; then
print_ok
    else
print_error "Puppet master not found\n 
				Please install puppet master before running this script\n
				Refer https://cwiki.apache.org/confluence/display/STRATOS/4.0.0+Configuring+Puppet+Master"
    fi
}

function get_confirmation(){
# Get user confirmation
    ${ECHO} -e "Puppetforge Module Installer"
    ${ECHO} -e "This script will install pupeptforge modules which are "
    ${ECHO} -e " specified in puppetforge.modules file"
    ${ECHO} -e ""
    ${ECHO} -e "Please check your input and confirm by pressing [Enter] to continue. "
    ${ECHO} -en "Or press [Ctrl] + [c] to stop the installationan exit. : "
    
read input

${ECHO} -e "Installation started. Please wait ... "
}

bashtrap(){
    print_error "\n[Ctrl] + [c] detected ... \nScript will exit now."
}

# Check all input parameters.
while getopts ":vh --help" opt; do
case ${opt} in
        h|--help)
            print_usage
            exit 0
            ;;
        v)
            VERBOSE=1
            ;;
        :)
            ${ECHO} -e "puppetforge: Option -${OPTARG} requires an argument."
            ${ECHO} -e "puppetforge: '--help or -h' gives usage information."
            exit 1
            ;;
         \?)
            ${ECHO} -e "puppetforge: Invalid option: -${OPTARG}"
            ${ECHO} -e "puppetforge: '--help or -h' gives usage information."
            exit 1
            ;;
    esac
done

# Check puppet is installed
check_for_puppet

# Get user confirmation
get_confirmation

INPUT=puppetforge.modules
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read module version
do
	if [[ -n $version ]]; then
        	puppet module install $module --version $version
	  else
		puppet module install $module
	fi
done < $INPUT
IFS=$OLDIFS

${ECHO} -e "Installation completed!"


