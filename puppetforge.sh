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

# This script will install puppet forge modules which are specified in puppetforge.modules
# It will read modules from modules file and install them to /etc/puppet/modules

# Requirements :
# Puppet should exist on system before running this script
# Refer https://cwiki.apache.org/confluence/display/STRATOS/4.0.0+Configuring+Puppet+Master to install puppet master on your system
#
# Usage :
# ./puppetforge.sh -v|-h|--help
#
# h|help => for help
# v => to enable verbose mode
#
# Usage of puppetforge.modules
# ============================
#
# Specify puppetforge modules you want to install on your puppet master.
# Don't worry about the dependent modules. Puppt Module Tool will find and download them automatically.
#
# Example 1 :
#	puppetlabs-apache
#	
#	Caution : It will download latest puppetlabs-apache module and all dependent modules to /etc/puppet/modules
#	
# Example 2 :
#	puppetlabs-apache, 1.1.1
#	
#	Caution : It will download puppetlabs-apache 1.1.1 module and all dependent modules (might be older ones) to /etc/puppet/modules
#			  
# Recommended way
# ===============
#
# Don't specify any version unless required. You will be guranteed to have latest modules.
# Please note that these versions are not actual software versions. These are puppet module's version.
# Hence, it is always better to install latest puppet module.


set -e

# General commands
ECHO=`which echo`

# Parameters
VERBOSE=0

# Execute bashtrap function when user press [Ctrl]+[c]
trap bashtrap INT

function print_usage(){    
    ${ECHO} -e " This script will install puppet forge modules which are specified in puppetforge.modules"
    ${ECHO} -e " It will read modules from modules file and install them to /etc/puppet/modules"
    ${ECHO} -e ""
    ${ECHO} -e " Requirements :"
    ${ECHO} -e " =============="
    ${ECHO} -e " Puppet should exist on system before running this script"
    ${ECHO} -e " Refer https://cwiki.apache.org/confluence/display/STRATOS/4.0.0+Configuring+Puppet+Master to install puppet master on your system"
    ${ECHO} -e ""
    ${ECHO} -e " Usage :"
    ${ECHO} -e " ======="
    ${ECHO} -e " ./puppetforge.sh -v|-h|--help"
    ${ECHO} -e ""
    ${ECHO} -e " h|help => for help"
    ${ECHO} -e " v => to enable verbose mode"
    ${ECHO} -e ""
    ${ECHO} -e " Usage of puppetforge.modules"
    ${ECHO} -e " ============================"
    ${ECHO} -e ""
    ${ECHO} -e " Specify puppetforge modules you want to install on your puppet master."
    ${ECHO} -e " Don't worry about the dependent modules. Puppt Module Tool will find and download them automatically."
    ${ECHO} -e ""
    ${ECHO} -e " Example 1 :"
    ${ECHO} -e "	puppetlabs-apache"
    ${ECHO} -e "	"
    ${ECHO} -e "	Caution : It will download latest puppetlabs-apache module and all dependent modules to /etc/puppet/modules"
    ${ECHO} -e ""
    ${ECHO} -e " Example 2 :"
    ${ECHO} -e "	puppetlabs-apache, 1.1.1"
    ${ECHO} -e ""
    ${ECHO} -e "	Caution : It will download puppetlabs-apache 1.1.1 module and all dependent modules (might be older ones) to /etc/puppet/modules"
    ${ECHO} -e ""
    ${ECHO} -e " Recommended way"
    ${ECHO} -e " ==============="
    ${ECHO} -e ""
    ${ECHO} -e " Don't specify any version unless required. You will be guranteed to have latest modules."
    ${ECHO} -e " Please note that these versions are not actual software versions. These are puppet module's version."
    ${ECHO} -e " Hence, it is always better to install latest puppet module."
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
    ${ECHO} -e ""	
    ${ECHO} -e "Puppetforge Module Installer"
    ${ECHO} -e "This script will install pupeptforge modules which are "
    ${ECHO} -e "specified in puppetforge.modules file"
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


