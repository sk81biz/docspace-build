#!/usr/bin/bash

DOCKER_TAG_OLD="develop"
DOCKER_TAG_NEW="develop-multiarch"
REPO="onlyoffice"
DOCKER_IMAGE_PREFIX="4testing-docspace"
BASE_NAME="sk81biz"

MODIFY=false

while [ "$1" != "" ]; do
    case $1 in

        --modify )
            if [ "$2" != "" ]; then
                MODIFY=$2
                shift
            fi
        ;;
        -to | --tagold )
            if [ "$2" != "" ]; then
                DOCKER_TAG_OLD=$2
                shift
            fi
        ;;
        -tn | --tagnew )
            if [ "$2" != "" ]; then
                DOCKER_TAG_NEW=$2
                shift
            fi
        ;;

        -rp | --repo )
            if [ "$2" != "" ]; then
                REPO=$2
                shift
            fi
        ;;

        -st | --status )
            if [ "$2" != "" ]; then
                DOCKER_IMAGE_PREFIX=$2
                shift
            fi
        ;;

        -bn | --basename )
            if [ "$2" != "" ]; then
                BASE_NAME=$2
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
arrayImagesName=($(docker image ls | grep "${DOCKER_TAG_OLD}" | grep "${DOCKER_IMAGE_PREFIX}" | grep "${BASE_NAME}" | awk '{print $1}' ))

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
