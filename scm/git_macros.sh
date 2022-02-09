##############
# GIT MACROS #
##############
#for linking repos to a local RAID
git.local.init(){
    raid.create.repo $1
}

# push a single module repo to the raid server and attach it as a remote
git.local.link.module(){
    modulename=`node -p "require('$1/package.json').name"`
    sshlogin=`raid.login.string`
    sourcepath=`raid.source.path`
    git.local.init $modulename #init a bare repo on the server
    cd $1
    git remote add raid "ssh://$sshlogin:$sourcepath/$modulename"
    git push -u raid master
    echo "linked $modulename."
}

# push a directory of module repos to the raid server and attach them as remotes
git.local.link.dir(){
    arrVar=()
    for path in $1/*
    do
      if [[ -d "$path" ]]
      then
        if [ -d "$path/.git" ]; then
          if [ -f "$path/package.json" ]; then
            git.local.link.module $path
          else
            arrVar+=($path)
          fi;
        else
          if [[ $path != *"/node_modules/"* ]]; then
            git.local.link.dir $path
          fi
        fi;
      fi
    done
    #echo "skipped:"
    #for value in "${arrVar[@]}"
    #do
    #     echo $value
    #done
}

git.local.link.this(){
    git.local.link.dir `pwd`
}

git.current.tag(){
    echo $(git describe $(git rev-list --tags --max-count=1))
}

git.oldest.commit(){
    diff -u <(git rev-list --first-parent ${1:-master}) <(git rev-list --first-parent ${2:-HEAD}) | sed -ne 's/^ //p' | head -1
}

git.newest.commit(){
    git log ${1:-master} -1 | head -1 | cut -d' ' -f 2
}

git.latest.pull.time(){
    node -p 'require("fs").statSync("./.git/FETCH_HEAD").mtime.getTime()'
}

git.last.pull(){
    PULLEDON=`git.previous.pull.date 2` #not this one, but the previous one
    PULLEDONFORMATTED=`date -r ${PULLEDON} +"%m-%d-%Y"`
    echo "$(tput setaf 6)Last Pull on ${PULLEDONFORMATTED}$(tput setaf 9)
"
    git --no-pager log --since=${PULLEDON}
}

git.all.releases(){
    node -e '(function(){require("child_process").exec("git branch -a | grep -F \"remotes/origin/release-\" -", function(err, result){ console.log(result.split("\n").map(function(item){ return item.trim().substring(23) }).filter(function(item){ return item !== "" }).join("\n")); }); return "";})()'
}

git.last.release(){
    node -e '(function(){require("child_process").exec("git branch -a | grep -F \"remotes/origin/release-\" -", function(err, result){ console.log(result.split("\n").map(function(item){ return item.trim().substring(23) }).filter(function(item){ return item !== "" }).pop()); }); return "";})()'
}

git.previous.pull.date(){
    node -e '(function(){var pulls = require("fs").readFileSync(".git/logs/HEAD").toString().split("\n").filter(function(line){ return line.indexOf("pull:") != -1 }); return /^([a-f0-9]+) ([a-f0-9]+) (.*) (<.*>) ([0-9]+) (-[0-9]{4})\t(.*)$/.exec(pulls[pulls.length-'${1}'])[5];})()'
}

git.log.line.timestamp(){
    sudo node -p '/^([a-f0-9]+) ([a-f0-9]+) (.*) (<.*>) ([0-9]+) (-[0-9]{4})\t(.*)$/.exec("'${1}'")[4];'
}

#git.release.report(){ }

git.last.fetched(){
    git log --since="`git.latest.pull.time`"
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

git.current.release(){
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
