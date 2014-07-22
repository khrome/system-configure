##############
# GIT MACROS #
##############
git.current.tag(){
    echo $(git describe $(git rev-list --tags --max-count=1))
}

git.oldest.commit(){
    diff -u <(git rev-list --first-parent ${1:-master}) <(git rev-list --first-parent ${2:-HEAD}) | sed -ne 's/^ //p' | head -1
}

git.newest.commit(){
    git log ${1:-master} -1 | head -1 | cut -d' ' -f 2
}

git.changelog(){
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative ${1}..${2:master}
}

git.update.submodules(){
    for repo in `find . -maxdepth 2 -mindepth 2 -wholename '*/.git'`
    do
        cd $repo/..
        echo "updating $(pwd)"
        remote='origin'
        #if [ `git remote | grep mootools` ]; then
        #	remote='mootools'
        #fi
        git fetch $remote
        git reset --hard $remote/master
        cd ..
    done
}

git.export(){
PWD=`pwd`
NAME=`basename $PWD`
TAG=`git.current.tag()`
if [ ! -f .gitattributes ]
then
    `git.init.attributes()`
fi
git archive --format=tar --prefix=${NAME}/ ${TAG} | bzip2 -9 > ${PWD}/../${NAME}-${TAG}.tar.bz2
}

git.init.attributes(){
    "/test export-ignore\
.gitattributes export-ignore\
.gitignore export-ignore" > .gitattributes
}

git.current.build(){
    echo $(git rev-list --all --max-count=1)
}

git.archive(){
    echo $(git archive -o archive.zip HEAD)
}

#git.robot.on(){
    #todo: support minute|hourly|daily|monthly|yearly
    # repo=$(basename `git rev-parse --show-toplevel`)
    #line="22 2 * * * $HOME/.config/system-configure/robot $HOME/$1"
    #(crontab -u `whoami` -l; echo "$line" ) | crontab -u `whoami` -
#}

#git.robot.off(){
    # repo=$(basename `git rev-parse --show-toplevel`)
    # ct=$(crontab -l)
    # line=$(awk '"/.config/system-configure/robot $HOME/$(repo)" {print NR - 1}' $(ct))
    # sed -i -e "$(line)d"
    # crontab - | $(ct)
#}

git.robo(){
    PATH="~/bin:/sbin:/bin:/var/sbin:/var/bin:/usr/local/bin:$PATH"
    cd "$1"
    git add -A .
    git commit -q -m 'automated update'
    git push -q
}