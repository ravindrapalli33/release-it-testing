#!/bin/sh

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD | tr '[:upper:]' '[:lower:]')"
MASTER_BRANCH="master"
DEVELOPMENT_BRANCH="development"
STAGING_BRANCH="staging"
PRODUCTION_BRANCH="production"

# EXIT if current branch is master
if [ $CURRENT_BRANCH = $MASTER_BRANCH ]; then
    echo "$(tput setaf 1)EXITING... \nReason: YOU ARE IN master BRANCH$(tput sgr0)"
    exit 0;
fi;

RELEASE_IT_COMMAND="release-it --config=.release-it.json"

LAST_TAG="$(git describe --abbrev=0 --tags)"
LAST_TAG=${LAST_TAG%-beta*}
LAST_TAG=${LAST_TAG%-rc*}

IS_LAST_TAG_RELEASED="$(git tag -l --sort=version:refname ${LAST_TAG})"

if [ $CURRENT_BRANCH = $DEVELOPMENT_BRANCH ]; then

    if [ $IS_LAST_TAG_RELEASED = $LAST_TAG ]; then
        echo "$(tput setaf 1)\nA version for this is already released to production it means the major, minor or patch should be increased$(tput sgr0)"
    fi;

    echo "$(tput setaf 3)\n#### POINTS TO CONSIDER WHEN DEPLOYING TO DEVELOPMENT BRANCH ####\n"
    echo "* DO NOT BUMP VERSION(MAJOR, MINOR OR PATCH TILL A PRODUCTION VERSION IS RELEASED FOR THAT TAG)\n"
    echo "* INCREMENT MAJOR, MINOR OR PATCH HERE (DECIDE WITH TEAM) 'ONLY' FOR THE FIRST TIME WHEN PRODUCTION VERSION IS RELEASED FOR THAT TAG AND THIS IS THE FIRST VERSION AFTER IT\n"
    echo "** SUBSEQUENT TIMES THE BETA VERSION IS AUTO INCREMENTED$(tput sgr0)\n"
    echo "$(tput setaf 2)******* VERIFY CONFLUENCE / SM FOR CONFIRMATION *******$(tput sgr0)"
    echo "$(tput setaf 3)\n############################\n$(tput sgr0)"

    echo "$(tput setaf 1)\nEnter 4 to continue without upgrade / do not proceed if unsure(Enter 5 to exit): $(tput sgr0)"

    PS3='Please select the version upgrade: '
    options=("Major" "Minor" "Patch" "Continue" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Major")
                RELEASE_IT_COMMAND+=" major"
                break
                ;;
            "Minor")
                RELEASE_IT_COMMAND+=" minor"
                break
                ;;
            "Patch")
                RELEASE_IT_COMMAND+=" patch"
                break
                ;;
            "Continue")
                break
                ;;
            "Quit")
                exit 0
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
fi;

if [ $CURRENT_BRANCH = $DEVELOPMENT_BRANCH ]; then
    RELEASE_IT_COMMAND+=" --preRelease=beta"
elif [ $CURRENT_BRANCH = $STAGING_BRANCH ]; then
    RELEASE_IT_COMMAND+=" --preRelease=rc"
elif [ $CURRENT_BRANCH = $PRODUCTION_BRANCH ]; then
    RELEASE_IT_COMMAND+=""
else
    RELEASE_IT_COMMAND = "git push origin " + $CURRENT_BRANCH;
fi;

$RELEASE_IT_COMMAND
