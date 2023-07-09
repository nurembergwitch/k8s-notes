#!/usr/bin/bash
CIDR_BASE_ADDR="$(minikube ip)"
  INGRESS_FIRST_ADDR="$(echo "${CIDR_BASE_ADDR}" | awk -F'.' '{print $1,$2,$3,2}' OFS='.')"
  INGRESS_LAST_ADDR="$(echo "${CIDR_BASE_ADDR}" | awk -F'.' '{print $1,$2,$3,255}' OFS='.')"
  INGRESS_RANGE="${INGRESS_FIRST_ADDR}-${INGRESS_LAST_ADDR}"
 echo ${INGRESS_RANGE}
