############################################
# system-configure                  khrome #
#------------------------------------------#
# v1.0.0
# 
# 
############################################

#System
source ${BASH_SOURCE%/*}/shell/shell_setup.sh
source ${BASH_SOURCE%/*}/shell/shell_services.sh

#System
source ${BASH_SOURCE%/*}/system/system_macros.sh
source ${BASH_SOURCE%/*}/system/network_macros.sh

#SCM
source ${BASH_SOURCE%/*}/scm/git_macros.sh
source ${BASH_SOURCE%/*}/scm/svn_macros.sh

#Languages
source ${BASH_SOURCE%/*}/languages/php_macros.sh
source ${BASH_SOURCE%/*}/languages/nodejs_macros.sh

#Applications
source ${BASH_SOURCE%/*}/applications/things_macros.sh
source ${BASH_SOURCE%/*}/applications/see_macros.sh

source ${BASH_SOURCE%/*}/web_dev.sh
