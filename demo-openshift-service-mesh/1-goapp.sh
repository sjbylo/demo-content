#!/bin/bash -e 
# Steps to load the demo app - no mesh

# Create the projects for the demo app 
oc new-project travel-agency   >/dev/null
oc new-project travel-portal   >/dev/null
oc new-project travel-control  >/dev/null

# Load the app
oc apply -f https://raw.githubusercontent.com/kiali/demos/master/travels/travel_control.yaml -n travel-control
oc apply -f https://raw.githubusercontent.com/kiali/demos/master/travels/travel_agency.yaml -n travel-agency
oc apply -f https://raw.githubusercontent.com/kiali/demos/master/travels/travel_portal.yaml -n travel-portal

# Expose the app
oc expose service control -n travel-control
oc get route -n travel-control

