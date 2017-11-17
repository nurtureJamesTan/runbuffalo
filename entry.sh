#!/bin/sh
echo "runbuffalo v1.1.0"

export APPDIR=/home/app/web
cd $APPDIR
if [ ! -f $APPDIR/env.sh ]; then
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

# pkill heroku
echo "Starting up $GO_ENV..."
gosu app $@ >> $APPDIR/log/out.log
