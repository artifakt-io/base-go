#!/bin/bash

set -e

echo ">>>>>>>>>>>>>> START CUSTOM BUILD SCRIPT <<<<<<<<<<<<<<<<< "

RUNTIME_NAME="Golang"
RUNTIME_LOGO="golang.png"
REPO_NAME=base-html
REPO_BRANCH=main
ARCHIVE_FILE=$REPO_NAME-$REPO_BRANCH
DOCROOT=/var/www/html/public

curl -sSLO https://github.com/artifakt-io/${REPO_NAME}/archive/refs/heads/${REPO_BRANCH}.tar.gz && \
	tar -xzf ${REPO_BRANCH}.tar.gz -C /tmp && \
	mkdir -p $DOCROOT
	mv /tmp/${ARCHIVE_FILE}/* $DOCROOT && \
	chown -R www-data:www-data $DOCROOT && \
	rm ${REPO_BRANCH}.tar.gz

sed -i "s/__RUNTIME_NAME__/${RUNTIME_NAME}/" $DOCROOT/index.html
sed -i "s/__RUNTIME_LOGO__/${RUNTIME_LOGO}/" $DOCROOT/index.html


echo ">>>>>>>>>>>>>> END CUSTOM BUILD SCRIPT <<<<<<<<<<<<<<<<< "
