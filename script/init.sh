#!/bin/bash

# handle ENVIRONMENT variables
rm -f /usr/src/app/tmp/pids/server.pid /usr/src/app/log/*.log
if [[ ${WATERMARK} ]]; then
    if [[ -z "${AUTH}" ]]; then
        export AUTH="true"
    fi
fi

# handle DB settings
if [ "$SEMCON_DB" == "external" ]
then
	cp config/database_pg.yml config/database.yml
fi
rake db:create
rake db:migrate


rails server -b 0.0.0.0 &
bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:3000/api/active)" != "200" ]]; do sleep 5; done'
/usr/src/app/script/init.rb "$1"
sleep infinity