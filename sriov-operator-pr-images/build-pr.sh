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
