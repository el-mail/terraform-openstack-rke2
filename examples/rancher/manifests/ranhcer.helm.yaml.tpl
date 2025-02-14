apiVersion: v1
kind: Namespace
metadata:
  name: cattle-system
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: rancher
  namespace: kube-system
spec:
  chart: rancher
  repo: https://releases.rancher.com/server-charts/stable
  targetNamespace: cattle-system
  bootstrap: True
  set:
    hostname: ${hostname}
    replicas: 1
    bootstrapPassword: ${bootstrapPassword}
