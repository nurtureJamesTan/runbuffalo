#!/bin/sh
echo "runbuffalo v1.3.0"

export APPDIR=/home/app/web
cd $APPDIR
if [ -f $APPDIR/stg-docker-private-env.sh ]; then
	. $APPDIR/stg-docker-private-env.sh
else
	. $APPDIR/env.sh
fi;

echo "preparing tmp..."
pwd

mkdir -p $APPDIR/tmp
mkdir -p $APPDIR/log
chown app -R $APPDIR/tmp $APPDIR/log
mkdir -p /go/src
ln -s /home/app/web /go/src/ossdc

if [ "$@" = "bash" ]; then
	echo "entering bash"
	bash -l
	exit 0
fi

# echo "migration & seeds..."
if [ "$MIGRATE" -eq 1 ]; then
	echo "db migrate and db:seed..."
	exec su app -c "bin/heroku migrate" >> $APPDIR/log/$GO_ENV.log
	exec su app -c "bin/heroku t db:seed" >> $APPDIR/log/$GO_ENV.log
fi

if [ "$CRON" -eq 1 ]; then
	echo "CRON $GO_ENV..."
	cat /home/app/web/cron_task.sh

	cp -rf /home/app/web/cron_task.sh /var/spool/cron/crontabs/root
	crond -l 2 -f
else
	# pkill heroku
	echo "Runing $GO_ENV: $@, UID $UID"
	exec su app -c "$@"
fi

