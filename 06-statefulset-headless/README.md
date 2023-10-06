Special things about statefulsets.

1. kind: StatefulSet must have a specified headless service in its configuration at level `.spec.serviceName`: some-headless-svc

2. Instead of separate PersistentVolumeClaims there is a specification `.spec.volumeClaimTemplates` like this:
volumeClaimTemplates: # used by statefulsets to create volumes
    - metadata:
        name: ss-data
      spec:
        accessModes:
          - "ReadWriteOnce"
        #storageClassName: "some-class"
        resources:
          requests:
            storage: "1Gi"

`.spec.template.spec.volumes` and `.spec.template.spec.containers.volumeMounts` are the same. This template isn't mounted anywhere but will be used automatically. 


3. Essentially, a headless service is a way of configuring DNS in a k8s cluster

Each SS pod can be accessed through its domain name - pod-1.its-headless-service.namespace.svc.cluster.local <-- its Stable Network ID

However, when configuring Ingress, you need to use a non-headless service for it, because the target service in Ingress must not contain any periods, i.e. you can't write backend.service.name: app-1.headless-service.

Since a headless service is DNS, and not a kubernetes entity, it cannot be referenced in Ingress configuration. Only a k8s entity can be.

When a SS pod is created, k8s controller automatically creates a label for it "statefulset.kubernetes.io/pod-name=[app-name-N]", therefore we can create a service for each pod. If you inspect each SS pod, this label and its value will be present. Refer to 02-services.yaml to see how it's done.

4. A special line in a ClusterIP service configuration (the one that is passed to Inrgess) if you need to set up access to a particular pod, is `.spec.selector.statefulset.kubernetes.io/pod-name: [app-name-N]`