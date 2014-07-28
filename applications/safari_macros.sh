safari(){
    osascript -e "tell application \"Safari\" to open location \"${1}\"" -e 'tell application "Safari" to set bounds of front window to {10, 60, 1200, 800}'
}

safari.cookies(){
XPATH='//dict[string and ./string[contains(., "'${1}'")]]'
    cat ~/Library/Cookies/Cookies.plist | xpathtool --oxml "${XPATH}"
}