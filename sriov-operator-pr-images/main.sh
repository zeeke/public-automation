#!/bin/bash

set -x

#git clone https://github.com/k8snetworkplumbingwg/sriov-network-operator /tmp/sriov-network-operator
#
## https://docs.github.com/en/rest/pulls/pulls?apiVersion=2022-11-28#list-pull-requests
#curl -L \
#  -H "Accept: application/vnd.github+json" \
#  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
#  -H "X-GitHub-Api-Version: 2022-11-28" \
#  https://api.github.com/repos/k8snetworkplumbingwg/sriov-network-operator/pulls?sort=updated

#pr_list=`gh pr list -R github.com/k8snetworkplumbingwg/sriov-network-operator`
pr_list=`gh pr list -R github.com/k8snetworkplumbingwg/sriov-network-operator --state open --json number,author,headRefName,url --template "{{- range . -}}
		{{- tablerow .url -}}
	{{- end -}}"`

while IFS= read -r line; do
    bash ./sriov-operator-pr-images/build-pr.sh $line
done <<< "$pr_list"
