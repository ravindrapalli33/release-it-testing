#!/bin/sh

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD | tr '[:upper:]' '[:lower:]')"
PRODUCTION_BRANCH="production"

AUTO_CHANGE_LOG_COMMAND="npx auto-changelog --stdout --config .auto-changelog.json"

if [ $CURRENT_BRANCH = $PRODUCTION_BRANCH ]; then
    AUTO_CHANGE_LOG_COMMAND+=" --tag-pattern \d+.\d+.\d+$"
fi;

$AUTO_CHANGE_LOG_COMMAND
