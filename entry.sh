#!/bin/sh
echo "runbuffalo v1.3.2"

export APPDIR=/home/app/web
cd $APPDIR
if [ -f $APPDIR/stg-docker-private-env.sh ]; then
	. $APPDIR/stg-docker-private-env.sh
else
	. $APPDIR/env.sh
fi;

echo "1:preparing tmp..."
pwd

mkdir -p $APPDIR/tmp
mkdir -p $APPDIR/log
chown app -R $APPDIR/tmp $APPDIR/log
mkdir -p /go/src
echo "2:linking web to /go/src/ossdc"
ln -s /home/app/web /go/src/ossdc

if [ "$@" = "bash" ]; then
	echo "3:entering bash"
	bash -l
	exit 0
fi

# echo "migration & seeds..."
if [ "$MIGRATE" -eq 1 ]; then
	echo "3:db migrate"
	bin/heroku migrate
	echo "3a:db seed"
	bin/heroku t db:seed
fi

if [ "$CRON" -eq 1 ]; then
	if [ "$GO_ENV" = "production" ]; then
		echo "4:CRON $GO_ENV..."
		cat /home/app/web/cron_task.sh
		cp -rf /home/app/web/cron_task.sh /var/spool/cron/crontabs/root
		echo "starting crond..."
		crond -l 2
	fi
	echo "starting twitter:update"
	bin/heroku t twitter:update
else
	# pkill heroku
	echo "4:Runing $GO_ENV: $@, UID $UID"
	exec su app -c "$@"
fi

