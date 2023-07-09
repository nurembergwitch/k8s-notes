#!/usr/bin/bash

deploychart():
{
    APP_VERSION="1.8.0"
    CHART_VERSION="4.7.0"   
    mkdir nginx-ingress-controller-manifests && cd nginx-ingress-controller-manifests
    helm template ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --version ${CHART_VERSION} --namespace ingress-nginx > ./nginx-ingress.${APP_VERSION}.yaml
}

main() {
    deploychart()
}