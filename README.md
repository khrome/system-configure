system-configure
----------------

A basic macro environment I used locally which was just a massive tangle of code, now segmented and normalized. I use it like this:

    cd ~
    mkdir .myconfig
    cd .myconfig
    touch environment.sh
    touch hosting.sh
    mkdir bin
    git clone git@github.com:khrome/system-configure.git
    "source ${BASH_SOURCE%/*}/environment.sh
    source ${BASH_SOURCE%/*}/system-configure/index.sh
    source ${BASH_SOURCE%/*}/hosting.sh" >> index.sh
    
Then use `environment.sh` to store all of your global environment variables and machine specific macros to store sensitive IPs/ports/configurations and `hosting.sh`  for macros for various hosts/services. I also give myself a `bin` folder for scripts I want to put in the shell path.
    
Then just enable it in `.profile_bash` :

    source ~/.myconfig/index.sh
    export PATH=~/.myconfig/bin:$PATH
    
All done.

Enjoy,
    
- Abbey Hawk Sparrow
    