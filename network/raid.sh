raid.host(){
    echo "$LOCAL_RAID_USER"
}

raid.source.path(){
    echo "$LOCAL_RAID_SOURCE_PATH"
}

raid.login.string(){
    echo "$LOCAL_RAID_USER@$LOCAL_RAID_HOST"
}

raid.login(){
    ssh `raid.login.string`
}

raid.create.repo(){
    ssh `raid.login.string` << EOF
  set -e
  cd /volume1/Source;
  mkdir $1
  cd $1
  git init --bare
EOF
}
