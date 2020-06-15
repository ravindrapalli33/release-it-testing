#!/bin/sh

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD | tr '[:upper:]' '[:lower:]')"
DEVELOPMENT_BRANCH="development"
STAGING_BRANCH="staging"

AUTO_CHANGE_LOG_COMMAND="npx auto-changelog --stdout --config .auto-changelog.json"

if [ $CURRENT_BRANCH = $DEVELOPMENT_BRANCH ]; then
    AUTO_CHANGE_LOG_COMMAND+=" --tag-pattern .+-beta.+"
elif [ $CURRENT_BRANCH = $STAGING_BRANCH ]; then
    AUTO_CHANGE_LOG_COMMAND+=" --tag-pattern .+-rc.+"
else
    AUTO_CHANGE_LOG_COMMAND+=" --tag-pattern \d+.\d+.\d+$"
fi;

$AUTO_CHANGE_LOG_COMMAND
