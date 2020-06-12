#!/bin/sh

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD | tr '[:upper:]' '[:lower:]')"
DEVELOPMENT_BRANCH="development"
STAGING_BRANCH="staging"

RELEASE_IT_COMMAND="release-it --config=.release-it.json"

if [ $CURRENT_BRANCH = $DEVELOPMENT_BRANCH ]; then
    RELEASE_IT_COMMAND+=" --preRelease=beta"
elif [ $CURRENT_BRANCH = $STAGING_BRANCH ]; then
    RELEASE_IT_COMMAND+=" --preRelease=rc"
fi;

$RELEASE_IT_COMMAND
