# Quick Azure Operator demo with Azure MySQL using ARO 4.4

# Prepare to create the secret, create the file "data"

Follow the Azure Service Operator's instructions.  

This is one way to create the needed secret from the Service Principle credentials:

Create a file with the following data. Ensure you replace the values with the proper Azure related values:

```
AZURE_TENANT_ID=XXXXXXXX-YYYY-ZZZZ-1111-222222222222
AZURE_SUBSCRIPTION_ID=xxxxxxxx-yyyy-zzzz-9999-888888888888
AZURE_CLIENT_ID=11111111-2222-3333-4444-555555555555
AZURE_CLIENT_SECRET=sssssseeeeecccccrrrrreeeeeettttttt
AZURE_CLOUD_ENV=AzurePublicCloud
```

# Create the needed secret

Using the above created "data" file:

```
oc create secret generic azureoperatorsettings --from-env-file=data -n openshift-operators 
```

# Install the Operator

Install ASO, as of writing - 0.37.0, with all the defaults using OCP Console.


# Workaround

Change the permissions for the azure-service-operator service account - run this once after ASO is installed: 

```
oc adm policy add-cluster-role-to-user cluster-admin -z azure-service-operator -n openshift-operators --rolebinding-name=azure-service-operator-workaround
```
Note: This was needed for v0.37.0 (as of end Sep 2020) and may not be needed in future versions of ASO. 
See this issue I created if you need to understand more: https://github.com/Azure/azure-service-operator/issues/1269 

# Create a new project

```
oc new-project test-aso
```

# Create the Azure MySQL Server and all needed configurations

First, check the manifests in the deploy-azure-mysql dir.  For example, check the region you want to deploy mysql in e.g. "location: australiaeast".

The example manifest files will create the following resources:

1. my-demo-mysqlserver - Create a MySQL server in location: "australiaeast".  
1. my-demo-mysqlfirewallrule-public - Allow public access to the DB.
1. mydb - Create a database in the MySQL server called "mydb".
1. my-demo-mysqluser - Create a user called "user" with access to the database "mydb".

Instantiate the manifests:
```
oc create -f deploy-azure-mysql
```

# Extract the MySQL user's secret information

Wait for all resources to be provisioned and extract the DB access credentials:

```
#eval `bin/ksec my-demo-mysqluser`   
eval `oc get secret my-demo-mysqluser -o go-template='{{range $k,$v := .data}}{{printf "%s='\''" $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"'\''\n"}}{{end}}'`
```
Note: My useful `ksec` script can also be used which is in this repo under the bin dir.

# Log into the DB 

```
mysql -h$fullyQualifiedServerName -u$username@$MySqlServerName -p$password -D$MySqlDatabaseName
```
Install the mysql CLI first!

Note, the username is made up of `<username>@<MySqlServerName>`

# Clean up

```
oc delete -f deploy-azure-mysql
oc delete project test-aso 
```


