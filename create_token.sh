#!/bin/bash
echo "Create service account for importing clusters"
oc create serviceaccount admin-import -n default
oc adm policy  add-cluster-role-to-user cluster-admin -z admin-import -n default
oc sa new-token -n default admin-import
