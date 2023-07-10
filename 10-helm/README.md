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

` helm template <release> <path to folder>/<repo/chart> [--values=myvalues.yaml] > helm-release-versionX.yaml`
or
` helm template kps prometheus-community/kube-prometheus-stack [--version 47.4.0 --namespace monitoring] > ./kps.0.66.0.yaml `

You could maintain this single yaml instead of an entire dir with charts.

# creating your own chart

` helm create <chart name>`

In the templates dir, every file will be essentially sent through a text processor. Default ones are examples.

# some testing
Created a 1- and 2-madstest.yaml files in templates dir, cleared out values.yaml and default contents of templates dir. 
In the helm chart dir all helm commands are valid. Like `helm install` or `helm upgrade` or `helm template`
`helm template .` spits out yaml of 1 and 2-madstest.yaml

The idea is: properties in the yaml in templates dir are read off the values.yaml file from the chart root dir. In the templated yaml they're referenced like {{ .Values.some.property }} so in the templated helm chart it corresponds to whatever is in the some: property: <value> section. 

./values.yaml:
    replicas: 3
./templates/deployment.yaml
    spec:
        replicas: {{ .Values.replicas }} 