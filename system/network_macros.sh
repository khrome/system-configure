######################
# OSX Network Macros #
######################
system.ip(){
    system.ip.primary
}

system.ip.connected(){ # This is specific to OS X
    IP=$( finger `whoami`| sed -n 's/.* from \([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/p')
        IPS=$(ifconfig | egrep -o -m 1 -e '(?:10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3}|172\.(?:16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31)\.[0-9]{1,3}\.[0-9]{1,3})')
        IPS=(${IPS})
        foonum=${#IPS}
        IP=''
        for ((i=0;i<$foonum;i++)); do
            TIP="${IPS[${i}]}"
            case "${#TIP}" in
                "0" ) ;;
                 *  )
                    case "$IP" in
                        "" ) IP=($TIP) ;;
                    esac
                ;;
            esac
            IP="$IP"
        done
        echo $IP
}

system.ip.primary(){
    ip.available | head -n 1
    #host `hostname` | head -1 | awk '{ print $NF }'
}

system.ip.available(){
OS=`uname`
IO="" # store IP
case $OS in
   Linux) IP=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`;;
   FreeBSD|OpenBSD|Darwin) IP=`ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}'` ;;
   SunOS) IP=`ifconfig -a | grep inet | grep -v '127.0.0.1' | awk '{ print $2} '` ;;
   *) IP="Unknown";;
esac
echo "$IP"
}