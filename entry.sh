#!/bin/sh
echo "runbuffalo v1.0.7"

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
gosu app bin/heroku migrate > log/$GOENV.log
gosu app bin/heroku t db:seed > log/$GOENV.log
# pkill heroku
echo "Starting up $GOENV..."
gosu app $@ > log/$GOENV.log
