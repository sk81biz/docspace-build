#!/bin/bash
set -xe
REPO="sk81biz"
DOCKER_IMAGE_PREFIX="4testing-docspace"
DOCKER_TAG="develop"
MODIFY=false

ARCH_LINUX=$(lscpu | grep Architecture | awk '{print $2}')

while [ "$1" != "" ]; do
    case $1 in

        --modify )
          if [ "$2" != "" ]; then
	      MODIFY=$2
	      shift
	  fi
     ;;
        --repo )
          if [ "$2" != "" ]; then
	      REPO=$2
	      shift
	  fi
     ;;
       --prefix )
          if [ "$2" != "" ]; then
             DOCKER_IMAGE_PREFIX=$2
             shift
          fi
    ;;

       --tag )
          if [ "$2" != "" ]; then
             DOCKER_TAG=$2
             shift
          fi
    ;;
        -? | -h | --help )
            echo " Usage: bash [PARAMETER] [[PARAMETER], ...]"
            echo "      -?, -h, --help             this help"
            echo "  Examples"
            exit 0
    ;;

		* )
			echo "Unknown parameter $1" 1>&2
			exit 1
		;;
    esac
  shift
done


if [ "$ARCH_LINUX" = "aarch64" ] ; then
	DOCKER_TAG_CHECK=${DOCKER_TAG}-arm
        LOCAL_IMAGES_LIST=($(docker image ls | grep ${DOCKER_TAG_CHECK} | awk '{print $1}'))
	print ${LOCA_IMAGES_LIST[@]}
	for item in ${!LOCAL_IMAGES_LIST[@]}; do
	  echo "${LOCAL_IMAGES_LIST[$item]}"
          echo "docker manifest create ${LOCAL_IMAGES_LIST[$item]}:develop-multiarch --amend ${LOCAL_IMAGES_LIST[$item]}:develop-amd --amend ${LOCAL_IMAGES_LIST[$item]}:develop-arm"
	  if [ "$MODIFY" = true ] ; then
              docker manifest create ${LOCAL_IMAGES_LIST[$item]}:develop --amend ${LOCAL_IMAGES_LIST[$item]}:develop-amd --amend ${LOCAL_IMAGES_LIST[$item]}:develop-arm
	      docker manifest push ${LOCAL_IMAGES_LIST[$item]}:develop --purge 
	  fi 
	done
fi	

if [ "$ARCH_LINUX" = "x86_64" ] ; then
	DOCKER_TAG_CHECK=${DOCKER_TAG}-amd
        LOCAL_IMAGES_LIST=($(docker image ls | grep ${DOCKER_TAG_CHECK} | awk '{print $1}'))
fi


#docker manifest create onlyoffice/ffvideo:6.0.0 --amend onlyoffice/ffvideo:6.0-arm64 --amend onlyoffice/ffvideo:6.0-amd64
#  docker manifest  push onlyoffice/ffvideo:6.0.0 --purge
