######################
# Web Conf Shortcuts #
######################

alias mongo-start="mongod --dbpath ~/data/db/ &"
alias mongo-start-dump="mongod -v --dbpath ~/data/db/ &"
alias apache-start="sudo /opt/local/apache2/bin/apachectl start"
alias apache-restart="sudo /opt/local/apache2/bin/apachectl restart"
alias apache-stop="sudo /opt/local/apache2/bin/apachectl stop"
alias apache-status="sudo /opt/local/apache2/bin/apachectl status"
alias mysql-start="sudo /opt/local/share/mysql5/mysql/mysql.server start"
alias mysql-restart="sudo /opt/local/share/mysql5/mysql/mysql.server restart"
#EVERYTHING ELSE
alias mysql-stop="sudo /opt/local/share/mysql5/mysql/mysql.server stop"
#OS X (annoying)
alias mysql.stop='sudo launchctl unload /Library/LaunchDaemons/com.oracle.oss.mysql.mysqld.plist'
alias memcache-start="/opt/local/bin/memcached -d"
alias rabbit-start="sudo rabbitmq-server &"
alias rabbit-manage="browse http://localhost:55672/mgmt/"
