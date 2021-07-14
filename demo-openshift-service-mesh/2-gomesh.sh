#!/bin/bash 
# Steps to add app to the mesh

oc delete route control -n travel-control

# Add projects into the mesh 
oc create -f  smm-basic.yaml  -n travel-control
oc create -f  smm-basic.yaml  -n travel-portal
oc create -f  smm-basic.yaml  -n travel-agency

sleep 1

oc get smmr default -n istio-system -o yaml| grep " configuredMembers:" -A4

