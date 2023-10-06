Diff ways to define env vars in a deployment: 

envFrom:
- secretRef:
    name: <name of secret or configmap>

^ the secret/configmap will contain key=value pairs that will be set as env vars

env:
- name: <variable name>
  value: <hardcoded value>

- name: <variable name>
  valueFrom:
    secretKeyRef/configMapKeyRef:
      name: <name of secret or configmap>
      key: <If I only want this and not all the keys in the secret>
