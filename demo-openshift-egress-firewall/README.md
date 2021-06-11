# Testing OpenShift egress Firewall

First, see the docs at:
https://docs.openshift.com/container-platform/4.7/networking/openshift_sdn/configuring-egress-firewall.html#domain-name-server-resolution_openshift-sdn-egress-firewall

## Create a pod containing curl 
```
oc new-project egress

oc create deployment fedora --image=fedora -- sleep 999999
```

## Set up the EgressNetworkPolicy CR

```
cat > enp.yaml <<END
apiVersion: network.openshift.io/v1
kind: EgressNetworkPolicy
metadata:
  name: default
spec:
  egress: 
  - type: Allow
    to:
      dnsName: bbc.com
  - type: Allow
    to:
      dnsName: www.bbc.com
  - type: Deny
    to:
      cidrSelector: 0.0.0.0/0
END

oc create -f enp.yaml
```

Note that, for the above example, the SDN will first resolve each domain name - bbc.com & www.bbc.com - and then Allow all resolved IP addresses.


## These calls should return 301, allowed
```
oc exec fedora-777d6488ff-5c88m -n egress -- curl --connect-timeout 5 -o /dev/null -s -w "%{http_code}\n" -I bbc.com
oc exec fedora-777d6488ff-5c88m -n egress -- curl --connect-timeout 5 -o /dev/null -s -w "%{http_code}\n" -I www.bbc.com
```

## These calls should be denied
```
oc exec fedora-777d6488ff-5c88m -n egress -- curl --connect-timeout 5 -o /dev/null -s -w "%{http_code}\n" -I wikipedia.com
oc exec fedora-777d6488ff-5c88m -n egress -- curl --connect-timeout 5 -o /dev/null -s -w "%{http_code}\n" -I fr.wikipedia.com
```

## Make changes and reconfig
```
oc delete -f enp.yaml; sleep 0.5; oc create -f enp.yaml
```

