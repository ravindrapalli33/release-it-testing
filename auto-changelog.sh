#!/bin/sh

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD | tr '[:upper:]' '[:lower:]')"
DEVELOPMENT_BRANCH="development"
STAGING_BRANCH="staging"
PRODUCTION_BRANCH="production"

AUTO_CHANGE_LOG_COMMAND="npx auto-changelog -p --config .auto-changelog.json"

if [ $CURRENT_BRANCH = $DEVELOPMENT_BRANCH ]; then
    AUTO_CHANGE_LOG_COMMAND+=" --tag-pattern .+-beta.+"
elif [ $CURRENT_BRANCH = $STAGING_BRANCH ]; then
    AUTO_CHANGE_LOG_COMMAND+=" --tag-pattern .+-rc.+"
elif [ $CURRENT_BRANCH = $PRODUCTION_BRANCH ]; then
    AUTO_CHANGE_LOG_COMMAND+=" --tag-pattern \d+.\d+.\d+$"
fi;

$AUTO_CHANGE_LOG_COMMAND
