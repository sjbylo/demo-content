# OpenShift Pipeline Demo

To demo the OpenShift Pipelines feature of OpenShift version 4 there are a couple of things that need to be done to 
ensure the default demos - provided by OpenShift - function correctly. 
If these configuration changes are not followed the pipeline will fail. 

Note that OpenShift Pipelines is a tech preview feature as of writing (OCP v4.6)

- Demo Setup 
  - Add the OpenShift Pipeline fature to your OpenShift cluster
    - As Cluster Administrator, install the Operator "Red Hat OpenShift Pipelines Operator - 1.2.1 provided by Red Hat" from the Administrator Console 
  - After the Operator has been installed and the "openshift-pipelines-operator" pod is running in the openshift-operators project, ensure the Pipeline option is visible in the Developer Console
- In the Developer Console 
  - Create a project 
  - Create an application in the usual way, e.g. with "From Git" or from "Container Image" or others, via the Developer Console's +Add menu item:
    - Using the "From Git" feature create a simple application using the following parameters:
    - Image URL: https://github.com/sclorg/django-ex.git 
    - Select the builder image "Python 3.6 (UBI 8)"
      - Select "Create Pipeline" (ensure the Pipeline feature Operator is installed, as above) 
        - If you see "There are no pipeline templates available for Python and Deployment combination", wait for the Operator to be install or refresh the paghe. 
    - Let the application finish building and launching
- Go to the Pipeline feature (in the Developer Console) 
  - Note that if you run this pipeline now it will fail because you need to add a persistent volume (PVC) 
  - Add a PVC:
    - Create a Persistent Volume Claim (PVC), e.g. 1GB in size (you may need to switch to the Administrator Console, but this can also be done directly in the Developer Console if you search for "PVC"). 
    - The PVC is used in the next step when the pipeline is stated 
  - Start the pipeline
    - If you start the pipeline without setting the PVC, you will see the error message: `mv: cannot stat /tmp/src/*: No such file or directory` in the build step
    - Ensure a PVC has been created, as described above.
    - Click on Pipeline Start
      - In the form verify all the values and fill in the missing values:
        - "Minor version" : This is the builder image version, e.g. 3.6 for python would mean "6" needs to be filled in.  This will use the following builder image: python-36-rhel7.  If you are interested, you can view the image in the RH registry, here: https://catalog.redhat.com/software/containers/rhel8/python-36/5ba244fc5a134643ef2f04ba 
      - For the Workspace, ensure the previously created PVC is selected (do not use "Empty Directory", otherwise the build will fail because the source code is missing: `mv: cannot stat /tmp/src/*: No such file or directory` 
    - View the pipeline executing the steps
    - Show each step executing 
  - Optional Demo
    - Show how to edit the pipeline directly in the Developer Console
    - Click on the pipeline and then on Actions -> Edit Pipeline 
    - Add a node between or in parallel with any of the existing nodes by clicking on the "+" sign 
      - select the "oc" task and accept all defaults 
      - Show how easy it is to add in tasks into the pipeline 


