######################
# PHP Macros         #
######################
composer(){
    php ${BASH_SOURCE%/*}/php/composer.phar ${*}
}