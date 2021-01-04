# OpenShift Pipeline Demo

To demo the OpenShift Pipelines feature of OpenShift version 4 there are a couple of things that need to be done to 
ensure the default demos - provided by OpenShift - function correctly. 
If these configuration changes are not followed the pipeline will fail. 

Red Hat OpenShift Pipelines Operator - 1.2.1 provided by Red Hat

Note that OpenShift Pipelines is a tech preview feature as of writing (OCP v4.6)

- Setup 
  - Ensure the OpenShift Pipeline Operator has been installed properly. 
  - After the Operator is installed, ensure the Piepline optiono 
- In the developer view 
- Create a project 
- Create an application in the usual way, e.g. with "From Git" or from "Container Image" or others, via the Developer Console's +Add menu item:
  - Using the "From Git" feature create a simple application using the following parameters:
  - Image URL: https://github.com/sclorg/django-ex.git 
    - Select "Create Pipeline" (ensure the feature Operator is installed, as above) 
      - If you see "There are no pipeline templates available for Python and Deployment combination", wait for the Operatopr to be installed properly. 
  - Let the application be built and launched 
- Go to the Pipeline feature (in the developer console) 
  - Note that if you run this pipeline now it will fail because you need to add a persistent volume (PVC) 
  - Add a PVC:
    - Create a Persistent Volume Claim (PVC), e.g. 1GB in size (you may need to switch to the Administrator view, but this can also be done directly in the Developer view if you search for PVC). 
    - You will use this PVC later when you start the pipeline 
  - Start the pipeline
    - Click on Pipeline Start
    - In the form check all values and fill in the missing values:
      - The "minor version" is the builder image version, e.g. 3.6 for python would mean "6" needs to be filled in.  This will use the following builder image: python-36-rhel7.  If you are interested, you can view the image in the RH registry, here: 
        - https://catalog.redhat.com/software/containers/rhel8/python-36/5ba244fc5a134643ef2f04ba 
      - For the Workspace, ensure the previously created PVC is selected (do not use "Empty Directory") 
    - View the pipeline executing the steps
    - Show each step executing 
  - Optional demo
    - Show how to edit the pipeline directly in the Developer Console
    - Click on Pipline -> Edit
    - Add a node between or in parallel with any of the existing nodes by clicking on the "+" sign 
      - select the "oc" task and accept all defaults 
      - Show how easy it is to add in tasks into the pipeline 


