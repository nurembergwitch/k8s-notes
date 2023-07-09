helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update
helm search repo istio[/base]

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

helm show values istio/base --version 1.17.1 > ../istio/istio-base-default.yaml

helm install istio-base istio/base --set defaultRevision=default --namespace istio-system --create-namespace --version 1.17.1