#!/bin/bash 
# Script to add or remove the auto-injection to all deployments in a ns or all mesh namespaces (via all smm)

val=true
[ `basename $0` == inject-remove-all.sh ] && val=false

[ "$1" ] && namespaces=$1 || namespaces=`oc get smm -A --output=jsonpath={.items..metadata.namespace}`

for ns in $namespaces
do
	echo "Injecting 'sidecar.istio.io/inject: true' into deployments in namespace $ns:"
	oc get deployment,dc -oname -n $ns \
		| xargs -L 1 oc patch --patch '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject": "'$val'"}}}}}' -n $ns
done



