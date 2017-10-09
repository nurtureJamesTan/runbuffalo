#!/bin/sh
echo "runbuffalo v1.0.6"

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
gosu app bin/heroku migrate
gosu app bin/heroku t db:seed
# pkill heroku
echo "Starting up..."
gosu app $@
