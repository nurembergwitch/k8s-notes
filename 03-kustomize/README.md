tbh not much to describe here
https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#customizing 

also everything is self-documented + comments

` kc kustomize <path to kz dir> `

` kc apply -k <path to kz dir> `


Base dir: contains exactly what you might think + an additional kustomization.yaml file with kz options

Overlays dir: contains specific environments.

** To deploy diff versions, create ./overlays, then a dir for each environment.

 there are 3 methods of patching:
    patches (like in test)
    patchesStrategicMerge (like in dev), but deprecated since Kustomize v5.0.0
    patchesJson6902 (like in prod)

                              WAYS TO GENERATE A CONFIGMAP

This goes in kustomization.yaml
configMapGenerator:
- name: mykustom-map
  env: config.properties

## according to the docs, configMapGenerator can also accept several files:
# configMapGenerator:
# - name: example-configmap-1
#   files:
#   - application.properties
#   - something.else

## or like this, for several environment files
# configMapGenerator:
# - name: example-configmap-1
#   envs:
#   - .env
#   - another.env

## or from a literal key-value pair:
# configMapGenerator:
# - name: example-configmap-2
#   literals:
#   - FOO=Bar
#   - BAR=Baz


                           WAYS TO PATCH A RESOURCE

1. This goes in kustomization.yaml. Best way that seems to work.
patches: 
  - target:
      kind: Deployment
    path: replicas.yaml
  - target:
      kind: Deployment
    path: set_memory.yaml  # specification of 128mi will be overridden with 512mi

...where both paths lead to specificly altered resources. You only need to keep the header and then override just the desired portion.

2. 
# https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#customizing
patchesStrategicMerge:
  - replicas.yaml # copied the header of the base yaml + only added what's to be changed

1 and 2 patch yamls are structured identically. keep the header and only alter the specific thing.

3. Seemingly deprecated way

patchesJson6902:
- target:
    group: apps # since im patching a deployment
    version: v1
    kind: Deployment
    name: mywebapp
  path: replicas.yaml

The patch replicas.yaml looks the following way:

- op: replace
  path: /spec/replicas
  value: 3
