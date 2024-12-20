#!/usr/bin/bash

DOCKER_TAG_OLD="develop"
DOCKER_TAG_NEW="develop-multiarch"
OLD_REPO="sk81biz"
NEW_REPO="onlyoffice"
DOCKER_IMAGE_PREFIX="4testing-docspace"

MODIFY=false

while [ "$1" != "" ]; do
    case $1 in

        --modify )
            if [ "$2" != "" ]; then
                MODIFY=$2
                shift
            fi
        ;;
        --oldtag )
            if [ "$2" != "" ]; then
                DOCKER_TAG_OLD=$2
                shift
            fi
        ;;
        --newtag )
            if [ "$2" != "" ]; then
                DOCKER_TAG_NEW=$2
                shift
            fi
        ;;
        --oldrepo )
            if [ "$2" != "" ]; then
                OLD_REPO=$2
                shift
            fi
        ;;
        --newrepo )
            if [ "$2" != "" ]; then
                NEW_REPO=$2
                shift
            fi
        ;;
        --prefix )
            if [ "$2" != "" ]; then
                DOCKER_IMAGE_PREFIX=$2
                shift
            fi
        ;;
        * )
            echo "Unknown parameter $1" 1>&2
            exit 1
        ;;
    esac
  shift
done

# Get docker images
arrayImagesName=($(docker image ls | grep "${DOCKER_TAG_OLD}" | grep "${DOCKER_IMAGE_PREFIX}" | grep "${OLD_REPO}" | awk '{print $1}' ))

# Modify docker image tag
for i in ${!arrayImagesName[@]}; do
    echo "== List items for chenges ==" 
    echo "${arrayImagesName[$i]}:${DOCKER_TAG_OLD}"
    echo "== Commited chenges result =="
    echo "${arrayImagesName[$i]}:${DOCKER_TAG_NEW}"
    if [ "$MODIFY" = true ] ; then   
        docker image tag ${arrayImagesName[$i]}:${DOCKER_TAG_OLD} ${arrayImagesName[$i]}:${DOCKER_TAG_NEW}
        docker image ls | grep ${DOCKER_TAG_NEW}
    fi
done
