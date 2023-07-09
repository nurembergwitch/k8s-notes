NGINX INGRESS SOME RETARDED WAY
    $ APP_VERSION="1.8.0"
    $ CHART_VERSION="4.7.0"
    $ mkdir nginx-ingress-controller-manifests && cd nginx-ingress-controller-manifests
    $ $ helm template ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --version ${CHART_VERSION} --namespace ingress-nginx > ./nginx-ingress.${APP_VERSION}.yaml
That created a manifest..

    `$ kkk create ns ingress-nginx`

    `$ kkk apply -f ./nginx-ingress.${APP_VERSION}.yaml (the created yaml)`
Wait for it to start.     

    `kkk create secret generic regcred --from-file=.dockerconfigjson=/home/mads/.docker/config.json --type=kubernetes.io/dockerconfigjson -n chat`

    `kkk apply -f chat-nginx-ingress-test.yaml`
