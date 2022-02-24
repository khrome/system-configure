############################################
# system-configure                  khrome #
#------------------------------------------#
# v1.0.0
#  Commented things are deprecated
#
############################################

#System
if [ -n "$ZSH_VERSION" ]; then
   THIS_DIRECTORY=${${(%):-%x}%/*}
elif [ -n "$BASH_VERSION" ]; then
   THIS_DIRECTORY="${BASH_SOURCE%/*}"
else
   echo "NOT A RECOGNIZED SHELL";
fi
source ${THIS_DIRECTORY}/shell/shell_setup.sh
source ${THIS_DIRECTORY}/shell/shell_services.sh

#System
source ${THIS_DIRECTORY}/system/system_macros.sh
source ${THIS_DIRECTORY}/system/network_macros.sh

#SCM
source ${THIS_DIRECTORY}/scm/git_macros.sh
#source ${BASH_SOURCE%/*}/scm/svn_macros.sh

#NETWORK
source ${THIS_DIRECTORY}/network/raid.sh

#Languages
source ${THIS_DIRECTORY}/languages/php_macros.sh
source ${THIS_DIRECTORY}/languages/nodejs_macros.sh

#Applications
#source ${BASH_SOURCE%/*}/applications/things_macros.sh
#source ${BASH_SOURCE%/*}/applications/see_macros.sh
source ${THIS_DIRECTORY}/applications/chrome_macros.sh

source ${THIS_DIRECTORY}/web_dev.sh

new.challenge(){
    cp -R ~/Development/challenge-boilerplate ~/Development/${1}
    cd ~/Development/${1}
    jq ".name = \"${1}\"" package.json > tmp.$$.json && mv tmp.$$.json package.json
    npm install

}

#ASCII Art
mp4.to.gif(){
    ffmpeg -ss ${3} -t ${4} -i ${1} -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 ${2}
}

movie.to.ansi(){
    mp4.to.gif ${1} ${1}.gif ${2} ${3}
    gif.to.ansi ${1}.gif
}

gif.to.ansi(){
    ls ${1}
    mkdir ${1}.dir
    mv ${1} ${1}.dir
    cd ${1}.dir
    convert -coalesce ${1} out%05d.jpg
    mkdir resized
    for f in *.jpg ; do (ascii-art image $f --posterize --stipple=#FFFFFF --blended --bit-depth 8 > resized/$f); done
}

play.frames(){
    for f in *.jpg ; do (cat resized/$f; sleep 0.1; (for f in {1..31} ; do printf "\033[F"; done)); done
}
