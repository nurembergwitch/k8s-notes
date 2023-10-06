# VERTICAL POD AUTOSCALING

1. Install a metrics server

Either bitnami: `helm install -f metrics.yaml metrics bitnami/metrics-server --version 6.4.3`

Or the official one: https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.6.4 It gets installed in kube-system namespace.
Apply the attached yaml or install as helm: `helm upgrade --install metrics-server metrics-server/metrics-server`

The usual error is patched with: kc edit deployment metrics-metrics-server, add a flag `--kubelet-insecure-tls=true` and/or `--kubelet-preferred-address-types="InternalIP"`. Or the patch yaml.


The example-deployment is requesting some resources: 
resources:
    requests:
        memory: "50Mi"
        cpu: "500m"
    limits:
        memory: "500Mi"
        cpu: "2000m"

If the pod uses more memor that in the limit, oom-killer will kill the pod and it will restart. If it uses more cpu than the limit, the linux kernel will throttle the pod cpu.

The goal is to set these as accurately as possible, but it's hard to guess.

Run `kc top pods` and see how many cores/memory the deployment is using. To make this shit scale automatically, a VPA is needed.

2. Install a VPA
https://github.com/kubernetes/autoscaler/blob/master/vertical-pod-autoscaler/README.md

`git clone https://github.com/kubernetes/autoscaler.git`

Run `bash vertical-pod-autoscaler/hack/vpa-up.sh` and watch the pods start up: `kc get all -n kube-system`

3. Deploy a VPA. Example configuration: 

apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: vpa-simple
spec:
  targetRef:                  # the deployment/statefulset it targets
    apiVersion: "apps/v1"
    kind: Deployment
    name: some-app
  updatePolicy: 
    updateMode: "Auto"
  resourcePolicy:
    containerPolicies:
      - containerName: "*"
        controlledResources: ["cpu", "memory"]


^ really cursed but chat pods don't work with this, straight up crash.
