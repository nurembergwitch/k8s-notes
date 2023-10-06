Deploying an app using argo you start by creating a pull request in the connected git repo, then argo applies the changes to the k8s cluster. Learn jenkins too, seriously.


1. Installation: https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/

installing with helm:
     `helm repo add argo https://argoproj.github.io/argo-helm`
     `helm install argo argo/argo-cd -n argo --create-namespace`

`kubectl port-forward service/argo-argocd-server -n argo 8080:443` - ui, password in `kubectl -n argo get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

# basic way of deployment

2. Create a git repo (argodemo in my case) for the future k8s manifests, which are located within another dir (myapp in my case), put some yamls in there as if it's a real project.

3. Now you need to tell argocd to watch this particular repo and ./argodemo/myapp path.
https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/

In the root dir where argocd was deployed, create a dir for an argocd CRD. In my case it is ./example-1.

Apply the created Application CRD, make sure the specified project is either default or actually exists. In the web UI (`kubectl port-forward service/argo-argocd-server -n argo 8080:443`) the status will be OutOfSync because that's the default policy, to not deploy automatically. 

Click "sync app", keep the defaults, and synchronize. 

Every time changes are made and pushed into the github repo, argocd will update the cluster.

# "app of apps" approach, using argo to create and delete apps using the same git repo

Let's say there are 2 dirs, myapp and myapp-2 with  some differences. You need an ./argodemo/environments dir to describe the current structure. Create a "staging" dir inside it and move myapp and myapp-2 in there.

To deploy apps automatically, create another dir in ./argodemo/environments/staging called "apps" (./argodemo/environments/staging/apps). Here will be all apps that I want in the staging environment described by some app resources: myapp.yaml and myapp-2.yaml.

Current structure of the argodemo git repo:
├── environments
│   └── staging
│       ├── apps
│       │   ├── myapp-2.yaml
│       │   └── myapp.yaml
│       ├── myapp
│       │   ├── 00-namespace.yaml
│       │   └── 01-deployment.yaml
│       └── myapp-2
│           ├── 00-namespace.yaml
│           └── 01-deployment.yaml
└── README.md

In the root dir, create ./example-2 with an appropriate Application resource to deploy both apps in the staging environment.


# private docker and git repos

Push a docker image to a private repo: 
     `docker tag nginx:1.23.3 dirt1922/nginx-private:v0.1` 
     `docker login` 
     `docker push dirt1922/nginx-private:v0.1` 
, provided that nginx-private docker repo exists.

Clone the private git repo, create the same app-of-apps structure, push changes to git.

Create a new example-3 dir for the new argocd configuration. The only difference is that the repo url will be like that: `repoURL: git@github.com:nurembergwitch/argodemo-private.git`

1 *** Argocd won't have access to the private git repo at the beginning (ComparisonError - error creating ssh agent). To authenticate, generate a new ssh key: 
     `ssh-keygen -t ed25519 -C "nurembergwitch github" -f ~/.ssh/argocd_ed25519`
Copy the created public key. In the private git repo -> settings -> deploy keys -> add deploy key.

2 *** After that, in the example-3 dir (the main argocd configuration) create a secret containing the public key (git-secret.yaml)

Apply the secret first: `kc apply -f example-3/git-secret.yaml`, then deal with docker:

3 *** In dockerhub -> account settings -> security -> new access token. Copy the token. Create a k8s secret for docker registry in the same ns as the app to deploy: 
     `kc create secret docker-registry regcred -n foo-private --docker-server="https://index.docker.io/v1/" --docker-username=dirt1992 --docker-password=<TOKEN> --docker-email=<email>`. 
Check that it was created: `kc get secrets -n foo -o yaml`. Add the "imagePullSecrets" section to the app deployment yaml (in the git repo): .spec.template.spec.imagePullSecrets: -name: regcred

ALTERNATIVELY: `kc create secret generic regcred --from-file=.dockerconfigjson=/home/mads/.docker/config.json --type=kubernetes.io/dockerconfigjson -n foo`

Commit all changes. Apply the argocd manifest again or refresh in the ui panel.


# helm
refer to example-4-helm/application.yaml for configuration. This one is the most straightforward and self-explanatory.



                                        # image updater

Installed from the helm chart as argocd itself: `helm install argo-image-updater argo/argocd-image-updater -n argo --create-namespace`
