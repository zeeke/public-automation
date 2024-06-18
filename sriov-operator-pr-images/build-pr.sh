#!/bin/bash

set -x

number=$1
author=$2
ref=$3
url=$4

if [ ! -d /tmp/sriov-network-operator ]; then
    git clone https://github.com/k8snetworkplumbingwg/sriov-network-operator /tmp/sriov-network-operator
fi

cd /tmp/sriov-network-operator
git checkout .

gh pr checkout $url

echo "ENV CLUSTER_TYPE=openshift" >> Dockerfile

TAG=`git branch --show-current`-`date +%Y%m%d`-`git rev-parse --short HEAD`

SRIOV_NETWORK_OPERATOR_IMAGE="ghcr.io/zeeke/sriov-network-operator:$TAG"
SRIOV_NETWORK_CONFIG_DAEMON_IMAGE="ghcr.io/zeeke/sriov-network-operator-config-daemon:$TAG"
SRIOV_NETWORK_WEBHOOK_IMAGE="ghcr.io/zeeke/sriov-network-operator-webhook:$TAG"

docker build -t ${SRIOV_NETWORK_OPERATOR_IMAGE} -f "Dockerfile" .
docker build -t ${SRIOV_NETWORK_CONFIG_DAEMON_IMAGE} -f Dockerfile.sriov-network-config-daemon .
docekr build -t ${SRIOV_NETWORK_WEBHOOK_IMAGE} -f Dockerfile.webhook .

echo $GITHUB_TOKEN | docker login ghcr.io -u zeeke --password-stdin

docker push ${SRIOV_NETWORK_OPERATOR_IMAGE}
docker push ${SRIOV_NETWORK_CONFIG_DAEMON_IMAGE}
docker push ${SRIOV_NETWORK_WEBHOOK_IMAGE}
