
# Remove projects from the mesh
oc delete smm -n travel-control --all
oc delete smm -n travel-portal --all
oc delete smm -n travel-agency --all

sleep 2
oc get smmr default -n istio-system -o yaml| grep " configuredMembers:" -A4

# Delete the projects 
oc delete project travel-agency travel-portal travel-control 

