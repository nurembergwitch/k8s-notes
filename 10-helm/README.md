# basics
`helm search repo <repo name>`

`helm search repo <repo name>[/<chart>] --versions`

`helm show values <repo/chart> > values.yaml` (you can edit them there and then upgrade the release)

`helm install <(arbitrary) name> <repo/chart>`

To change the values:
```
helm upgrade <name> <repo/chart> --set -n <namespace>
helm upgrade <name> <repo/chart> -f values.yaml -n <namespace>
helm upgrade <name> --values=myvalues.yaml <repo/chart>/<chart dir> -n <namespace>
```
To get user-supplied values:
`helm get values <release> -n <namespace>`

Make sure you specify the parent of the parameter youre changing, for example:
    helm upgrade monitoring prometheus-community/kube-prometheus-stack --set grafana.adminPassword=admin -n monitoring

Pull a chart:  `helm pull --untar prometheus-community/kube-prometheus-stack`. Values file comes included.

# generating yaml to use instead of helm charts

` helm template <release> <path to folder>/<repo/chart> --values=myvalues.yaml`
` helm template kps prometheus-community/kube-prometheus-stack --version 47.4.0 --namespace monitoring > ./kps.0.66.0.yaml `

You could maintain this single yaml instead of an entire dir with charts.

# creating your own chart

` helm create <chart name>`

In the templates dir, every file will be essentially sent through a text processor. Default ones are examples.