Everything is standard: first apply all roles and rolebindings, then deploy traefik, then the actual app deplotment. Ingress will be picked up by traefik.

To access the dashboard you need to port-forward:
    ` kc port-forward svc/traefik-dashboard-service 8080:8080 `

The app itself needs to be port-forwarded:
    ` $ kc port-forward svc/whoami 8082:80 `