cat <<EOF | oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: bad-developer
  labels:
    app: bad-developer  
---
apiVersion: apps.open-cluster-management.io/v1
kind: Channel
metadata:
  name: bad-developer
  namespace: bad-developer
  labels:
    app: bad-developer
spec:
  type: GitHub
  pathname: https://github.com/waynedovey/bad-developer.git
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: bad-developer-dev-clusters
  namespace: bad-developer
  labels:
    app: bad-developer  
spec:
  clusterConditions:
    - type: OK
  clusterSelector:
    matchExpressions: []
    matchLabels:
      environment: dev
---
apiVersion: app.k8s.io/v1beta1
kind: Application
metadata:
  name: bad-developer
  namespace: bad-developer
  labels:
    app: bad-developer  
spec:
  componentKinds:
  - group: apps.open-cluster-management.io
    kind: Subscription
  descriptor: {}
  selector:
    matchExpressions:
    - key: app
      operator: In
      values:
      - bad-developer
---
apiVersion: apps.open-cluster-management.io/v1
kind: Subscription
metadata:
  name: bad-developer
  namespace: bad-developer
  labels:
    app: bad-developer
  annotations:
      apps.open-cluster-management.io/github-path: resources/bad-developer
spec:
  channel: bad-developer/bad-developer
  placement:
    placementRef:
      kind: PlacementRule
      name: bad-developer-dev-clusters
      apiGroup: apps.open-cluster-management.io     
EOF
