#!/bin/sh

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
PRODUCTION_BRANCH="production"

AUTO_CHANGE_LOG_COMMAND="npx auto-changelog -p --config .auto-changelog.json"

if [ $CURRENT_BRANCH = $PRODUCTION_BRANCH ]; then
    AUTO_CHANGE_LOG_COMMAND+=" --tag-pattern \d+.\d+.\d+$"
fi;

TAG_LENGTH="$(git tag | wc -l)"
if [ "$1" = "FIRST_TAG_CHECK" ] && ([ $TAG_LENGTH = 0 ] || [ $TAG_LENGTH = 1 ]); then
    $AUTO_CHANGE_LOG_COMMAND
    echo "$(git add . && git commit -m 'Updated change log' && git push origin $CURRENT_BRANCH)"
elif ["$1" = "UPDATE"]; then
    $AUTO_CHANGE_LOG_COMMAND
fi;
