to run a daemonset you need a cluster with multiple nodes, or not i guess.
DaemonSets run on every single node in the cluster.

deploy the ds (` kkk apply -f 00-ds*.yaml`)

check logs ` kkk logs <pod name>`

https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/#communicating-with-daemon-pods 

exec into the pod: 
    kkk exec -it pod/example-daemonset-m94l7 -- sh
and see the env vars: 
    printenv
... or `curl -i localhost` to see the logged info (that's basically curling the ClusterIP service dns, which is descriibed in the alternative approach below)

***Alternatively, give the daemonset a ClusterIP service and create a pod (just a pod) 
    `kkk apply -f 01-*.yaml -f 02-*/yaml`

By using `kkk describe service/daemonset-svc-clusterip` you can see the endpoint to which it's pointing, that is the daemonset-communicate pod.
Exec into the lonely pod (`kkk exec -it pod/pod -- sh`) and curl the endpoint, dns of which is just it's name:
    ` curl http://daemonset-svc-clusterip:port `

Note: if there're multiple nodes on which the ds is running, curling the ds service will always hit a different node.

            HOW TO TALK TO A SPECIFIC POD IN A DAEMONSET?

Add a .ports.hostPort specification to the desired ds container

` kc get nodes -o wide ` to get the node ip
Now you can `curl -i 192.168.1.14:3000 (specified hostPort)` right from the node itself.

        WITH A HEADLESS SERVICE

` kc apply -f 03-headless*.yaml`
Now every ds pod in the cluster will get its own dns address. How to discover the dns?

1.  querying the dns of the headless service (its generally in the form of service.ns.svc.cluster.something). Exec into the lonely pod and `apk add --no-cache bind-tools`. Then:
    dig daemonset-svc-headless.default.svc.cluster.local
For example, one of the pod addresses was 10.42.0.28, which you now can curl.

2. call the k8s api: `kc describe endpoints daemonset-svc-headless`.
You can get A records of each pod by digging the following format: <pod-ip>.<ns>.pod.<cluster-domain>, where cluster-domain in my case is cluster.local

Exec into the lonely pod, `curl -i 10-42-0-28.default.pod.cluster.local`