##############
# OSX Macros #
##############
browse(){
    osascript -e "tell application \"Google Chrome\" to open location \"${1}\"" -e 'tell application "WebKit" to set bounds of front window to {10, 60, 1200, 800}'
}

browse.cookies(){
XPATH='//dict[string and ./string[contains(., "'${1}'")]]'
    cat ~/Library/Cookies/Cookies.plist | xpathtool --oxml "${XPATH}"
}

system.name(){
    uname -n
}

system.os(){
    uname
}

system.kernel.ext(){
    kextstat -kl | awk ' !/apple/ { print $6 } '
}

dock.remove(){
    /Applications/${1}.app/Contents/Info LSUIElement 1
}

dock.add(){
    /Applications/${1}.app/Contents/Info LSUIElement 0
}

alias system.kernel.extensions="kextstat -kl | awk ' !/apple/ { print $6 } '"

finder.alias(){
    echo "tell application \"Finder\" to make alias file to (POSIX file \"${1}\") at (POSIX file \"${2}\")"
    osascript -e "tell application \"Finder\" to make alias file to (POSIX file \"${1}\") at (POSIX file \"${2}\")"
}
alias finder.kill='KillAll Finder'
alias finder.hidden.show='defaults write com.apple.finder AppleShowAllFiles TRUE'
alias finder.hidden.hide='defaults write com.apple.finder AppleShowAllFiles FALSE'
