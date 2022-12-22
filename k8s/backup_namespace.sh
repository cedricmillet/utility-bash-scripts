#!/bin/bash
# Backup entire cluster ? ==> Use kubectl cluster-info dump > cluster_dump.txt
# Backup specific resources from specific namespace ? ==> Use this script


resources="ns,pvc,deploy,svc,ingress,secret,configmap,role,serviceaccount"
namespaces=( default 2ndNamespace 3rdNamespace )

for ns in ${namespaces[@]}; do
    echo "[$ns] Backup of $resources"

    kubectl --namespace="${ns}" get -o=json $resources | \
    jq '.items[] |
    select(.type!="kubernetes.io/service-account-token") |
    del(
        .spec.clusterIP,
        .metadata.uid,
        .metadata.selfLink,
        .metadata.resourceVersion,
        .metadata.creationTimestamp,
        .metadata.generation,
        .status,
        .spec.template.spec.securityContext,
        .spec.template.spec.dnsPolicy,
        .spec.template.spec.terminationGracePeriodSeconds,
        .spec.template.spec.restartPolicy
    )' >> "./${ns}.json"

done