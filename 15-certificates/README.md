Source: jeff
https://cert-manager.io/v1.0-docs/installation/kubernetes/
https://cert-manager.io/docs/installation/kubectl/
https://cert-manager.io/docs/installation/verify/
https://cert-manager.io/docs/tutorials/getting-started-aks-letsencrypt/#create-a-clusterissuer-for-lets-encrypt-staging 

Cert-manager needs to have certain Custom Resoruce Definitions in the cluster. You can install it with a manifest you can download and track in version control, or Helm. 

*** with HELM (https://artifacthub.io/packages/helm/cert-manager/cert-manager)
    $ helm repo add helm repo add jetstack https://charts.jetstack.io 
    $ helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.12.0 --set installCRDs=true 
Verify installation:
    $ kc get pods -n cert-manager

After this, you need a ClusterIssuer. Refer to cluster-issuer-example-jeff.yml.
    $ kc apply -f cluster-issuer-example-jeff.yml
    $ kc get clusterissuer


After making sure that cert-manager pods are running in its namespace, you need to configure a Cluster Issuer https://cert-manager.io/docs/configuration/
https://cert-manager.io/docs/tutorials/getting-started-aks-letsencrypt/#create-a-clusterissuer-for-lets-encrypt-staging 


After making sure it works, update the Ingress record for your cluster. Add a line metadata.annotations.cert-manager.io/cluster-issuer: <name of your cert>
    $ kc apply -f drupal.yml (or whatever youre using to configure ingress)


               =========== Basic certbot and lets encrypt ==========
Source: https://www.youtube.com/watch?v=jrR_WfgmWEw 

Let's say you have a server with some public ip, madsu.com 46.22.56.25, it has a DNS record at some cloud provider.

Now the task is to run Certbot behind the domain to prove ownership.

1. You can run certbot in a docker container. Dockerfile is in this dir.

`docker build . -t certbot`

`docker run -it --rm --name certbot -v ${PWD}:/letsencrypt -v ${PWD}/certs:/etc/letsencrypt certbot bash`
./certs dir is for all generated certificates.

2. Run nginx and mount the config + certbot data into the container.

The nginx.conf is configured to serve files from the same directory the docker-certbot is writing to.

`docker run -it --rm --name nginx -v ${PWD}/nginx.conf:/etc/nginx/nginx.conf -v ${PWD}:/letsencrypt -v ${PWD}/certs:/etc/letsencrypt -p 80:80 -p 443:443 nginx`

This way /letsencrypt from certbot container is written to pwd which is mounted to /letsencrypt in the nginx container, and the same thing happens with local ./certs and /etc/letsencrypt in the certbot/nginx container. Therefore "root /letsencrypt/;" in nginx.conf is a valid configuration, it will have all the files from pwd.

3. Enter the certbot container and run:
`certbot certonly --webroot` where --webroot is the mounted dir, i.e. /letsencrypt. The webroot is the dir nginx is going to serve web challenges from, which is specified in nginx.conf

After that all the generated certs will be available in local pwd as well as in both containers.

This dir with certs must be backed up in some way.


TO RENEW: Just run `certbot renew [--dry-run]`, you can set up a cronjob for it

Nginx has a graceful reload command in case the cert has changed: `nginx -s reload`



                            ==== CERTBOT AND LETSENCRYPT FOR KUBERNETES ====

Source: https://www.youtube.com/watch?v=7m4_kZOObzw

# CASE 1: no prev certs

1. Launch kube-prometheus-stack.

Edit kube-prometheus-stack values and set `serviceMonitorSelector.matchLabels.prometheus: prom-mads`
`helm upgrade kps -n monitoring prometheus-community/kube-prometheus-stack --values=./kubernetes/prometheus/values.yaml`

Or apply the patch

2. Install cert-manager helm chart with the values that specify this prometheus.

`helm install cert-manager jetstack/cert-manager --namespace cert-manager --values=./prometheus/values.yaml --version v1.12.2 --create-namespace`

Or if you already have cert-manager installed, patch the chart:
`helm upgrade cert-manager jetstack/cert-manager -n cert-manager --values=./cert-manager/values-patch.yaml`

3. Apply 01 and 02 yamls, look at configuration inside them. 

4. `kc get secret/madsuchat-com-key-pair -n cert-manager -o yaml` - look at the 3 generated certs.
Take ca.crt and base64 decode it.

For a human-readable format: `openssl x509 -in ca.crt -text -noout`

# CASE 2: generate a TLS cert using CA

If you have a certificate, you only need to import it to kubernetes using a secret. 