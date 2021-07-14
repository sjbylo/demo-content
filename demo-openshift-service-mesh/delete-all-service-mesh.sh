#!/bin/bash 
# Saf way to remove all of OSCP and any associated mesh projects

SMCP_NAME=basic
ISTIO_SYSTEM_NS=istio-system 

wait_proj_delete()
{
	echo -n "Waiting for project to be deleted ..."
	while oc get project $1 2>/dev/null >&2
	do
		sleep 1
		echo -n .
	done
	echo " done"
}

# Delete all SMMs that belong to $ISTIO_SYSTEM_NS SMCP
oc get smm -A | grep $ISTIO_SYSTEM_NS/$SMCP_NAME | awk '{print $1, $2}' | while read ns name
do
	echo Deleting smm $name in project $ns
	oc delete smm $name -n $ns

	# Delete the app/proj
	echo Deleteing project $ns
	oc delete project $ns
	
	# Collect the ns names
	names="$ns $names"
done

# Wait for projects to be deleted
for n in $names
do
	echo Wating for project $n to be fully deleted
	wait_proj_delete $n
done

oc delete smmr --all -n $ISTIO_SYSTEM_NS

# Delete the CP
echo Deleting the control plane 
oc delete smcp --all -n $ISTIO_SYSTEM_NS

# Wait for CP to be removed 
sleep 5

# Delete the CM project 
oc delete project $ISTIO_SYSTEM_NS

wait_proj_delete $ISTIO_SYSTEM_NS 

