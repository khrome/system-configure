##################
# Cordova MACROS #
##################

cordova.create(){
    mkdir ${CORDOVA_DEVELOPMENT_ROOT}/$1
    #${CORDOVA_ROOT}/cli/lib/cordova-ios/bin/create ${CORDOVA_DEVELOPMENT_ROOT}/$1/ios $2 $1
    ${CORDOVA_ROOT}/cli/lib/cordova-android/bin/create ${CORDOVA_DEVELOPMENT_ROOT}/$1/android $2 $1
}


#cordova.build (){
# Ê Ê/Users/stylepage/Sites/$1/cordova/debug
#}
#cordova.emulate (){
# Ê Ê/Users/stylepage/Sites/$1/cordova/emulate
#}
#cordova.log (){
# Ê Ê/Users/stylepage/Sites/$1/cordova/log
#}

weinre-start(){
    HOST=`ip.primary`
    COMD="weinre -httpPort 8085 -boundHost ${HOST}"
    `(nohup ${COMD} > foo.out 2> foo.err < /dev/null &)`
    ADDR="http://${HOST}:8085/client"
    browse $ADDR
    echo $HOST | pbcopy #put the current address into the clipboard
}

weinre-stop(){
    ps -ef | grep weinre | grep -v grep | awk '{print $2}' | xargs kill -9
}