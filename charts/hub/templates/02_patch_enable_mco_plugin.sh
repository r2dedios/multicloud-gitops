apiVersion: batch/v1
kind: Job
metadata:
  name: enable-odf-plugin
  annotations:
    argocd.argoproj.io/sync-wave: "0"
    argocd.argoproj.io/hook: "PostSync"
    #argocd.argoproj.io/hook-delete-policy: HookSucceeded
  namespace: openshift-storage
spec:
  template:
    spec:
      containers:
      - name: enable-odf-plugin
        command:
            - /bin/bash
            - -c
            - |
              echo "Patching the console to enable MCO console plugin"
              oc patch consoles.operator.openshift.io cluster -n openshift-storage --patch '{ "spec": { "plugins": ["odf-multicluster-console"] } }' --type=merge
              if [ $? = 0 ]
              then
                  echo "MCO console enabled, patch was applied ok"
              else
                  echo "Failed to patch console"
              fi
        image: registry.redhat.io/openshift4/ose-cli:v4.7
      restartPolicy: Never
      serviceAccount: patch-sa
