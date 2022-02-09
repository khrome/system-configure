chrome(){
    osascript -e "tell application \"Google Chrome\" to open location \"${1}\"" -e 'tell application "WebKit" to set bounds of front window to {10, 60, 1200, 800}'
}

#chrome.updates.off(){

#}

#chrome.updates.on(){

#}

chrome.cookies(){
#XPATH='//dict[string and ./string[contains(., "'${1}'")]]'
    #cat ~/Library/Cookies/Cookies.plist | xpathtool --oxml "${XPATH}"
    #sqlite3 ~/Library/AppSup/Google/Chrome/Default/Cookies
    #DB="~/Library/Application\\\\ Support/Google/Chrome/Default/Cookies"
    echo "woo"
    QUERY='select * from cookies where host_key like "%'${1}'" limit 1;'
    ACTION='sqlite3 ~/Library/AppSup/Google/Chrome/Default/Cookies "'$QUERY'"';
    echo "$QUERY"
    echo ${ACTION}
    LIST=$($ACTION);
    echo "hoo"
    # For each row
    for ROW in $LIST; do

        # Parsing data (sqlite3 returns a pipe separated string)
        Id=`echo $ROW | awk '{split($0,a,"|"); print a[1]}'`
        Name=`echo $ROW | awk '{split($0,a,"|"); print a[2]}'`
        Value=`echo $ROW | awk '{split($0,a,"|"); print a[3]}'`

        # Printing my data
        echo -e "\e[4m$Id\e[m) "$Name" -> "$Value;

    done
}
