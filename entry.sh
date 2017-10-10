#!/bin/sh
echo "runbuffalo v1.0.9"

export APPDIR=/home/app/web
cd $APPDIR
if [ ! -f $APPDIR/env.sh ]; then
  source $APPDIR/stg-docker-private-env.sh
else
	source $APPDIR/env.sh
fi;

echo "preparing tmp..."
gosu app mkdir -p $APPDIR/tmp
echo "migration & seeds..."
gosu app bin/heroku migrate >> log/$GO_ENV.log
gosu app bin/heroku t db:seed >> log/$GO_ENV.log
# pkill heroku
echo "Starting up $GO_ENV..."
gosu app $@ >> log/out.log
