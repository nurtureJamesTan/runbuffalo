#!/bin/sh
echo "runbuffalo v1.2.3"

export APPDIR=/home/app/web
cd $APPDIR
if [ -f $APPDIR/stg-docker-private-env.sh ]; then
  source $APPDIR/stg-docker-private-env.sh
else
	source $APPDIR/env.sh
fi;

echo "preparing tmp..."
pwd
gosu app mkdir -p $APPDIR/tmp
gosu app mkdir -p $APPDIR/log
# echo "migration & seeds..."

if [[ "$MIGRATE" -eq 1 ]]; then
gosu app bin/heroku migrate >> $APPDIR/log/$GO_ENV.log
gosu app bin/heroku t db:seed >> $APPDIR/log/$GO_ENV.log
fi

if [[ "$CRON" -eq 1 ]]; then
	echo "CRON $GO_ENV..."
	cat /home/app/web/cron_task.sh

	cp -rf /home/app/web/cron_task.sh /var/spool/cron/crontabs/root
	crond -l 2 -f
elif [[ $@ -eq "bash" ]]; then
	echo "entering bash"
	bash -l
else
	# pkill heroku
	echo "Runing $GO_ENV: $@, UID $UID"
	gosu app $@
fi

