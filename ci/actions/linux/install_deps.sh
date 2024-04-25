#!/bin/bash

set -x

echo "Script ci/actions/linux/install_deps.sh starting COMPILER=\"$COMPILER\""

# This enables IPv6 support in docker, needed to run node tests inside docker container
sudo mkdir -p /etc/docker && echo '{"ipv6":true,"fixed-cidr-v6":"2001:db8:1::/64"}' | sudo tee /etc/docker/daemon.json && sudo service docker restart

ci/build-docker-image.sh docker/ci/Dockerfile-base pawr/pawr-env:base
if [[ "${COMPILER:-}" != "" ]]; then
    ci/build-docker-image.sh docker/ci/Dockerfile-${COMPILER} pawr/pawr-env:${COMPILER}
else
    ci/build-docker-image.sh docker/ci/Dockerfile-gcc pawr/pawr-env:gcc
    ci/build-docker-image.sh docker/ci/Dockerfile-clang pawr/pawr-env:clang
    ci/build-docker-image.sh docker/ci/Dockerfile-centos pawr/pawr-env:centos
fi

echo "Script ci/actions/linux/install_deps.sh finished"
