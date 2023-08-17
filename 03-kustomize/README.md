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
