######################
# PHP Macros         #
######################
composer(){
    php ${BASH_SOURCE%/*}/php/composer.phar ${*}
}

alias composer@7.3='php@7.3 $(which composer)'
alias artisan@7.3='php@7.3 artisan'
