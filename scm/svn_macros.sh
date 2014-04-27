##############
# SVN MACROS #
##############

#remove all SVN directories under pwd()
cleanSVN(){
    echo "About to remove:"
    find . -type d -name .svn
    read -n1 -p "<C>ontinue, <A>bort Please choose one. "
    echo
    case $REPLY in
       c | C)
       echo "Removing SVN directories...."
       rm -rf `find . -type d -name .svn`
       echo "Done"
       ;;
       a | A)
       echo "Cancelled, directories left intact."
       ;;
       * )
       echo "Error, invalid response"
       ;;
    esac
}

alias svn.purge='find ./ -name ".svn" -exec rm -rf "{}" \;'

# Get the current revision of a local checkout
svn_revision(){
    svn info $@ | awk '/^Revision:/ {print $2}'
}

# Get the current revision of a repository
svn_server_revision(){
    svn info -r 'HEAD' | awk '/^Revision:/ {print $2}'
}

svn_changelog(){
    svn log -v --xml -rHEAD:$((`svn info | awk '/^Revision:/ {print $2}'` + 1)) | xsltproc -o ./changlog.html ~/Shell/htmlLog.xsl -
    open ./changlog.html
}

# Does an svn up and then displays the changelog between your previous
# version and what you just updated to.
svn_up(){
  local old_revision=`svn_revision $@`
  local first_update=$((${old_revision} + 1))
  svn up -q $@
  if [ $(svn_revision $@) -gt ${old_revision} ]; then
    svn log -v -rHEAD:${first_update} $@
  else
    echo "No changes."
  fi
}

# Displays changes on the server which you don't have
svn_next(){
  local old_revision=`svn_revision $@`
  local first_update=$((${old_revision} + 1))
  local new_revision=`svn_server_revision $@`
  if [ ${new_revision} -gt ${old_revision} ]; then
    svn log -v -rHEAD:${first_update} $@
  else
    echo "No changes."
  fi
}