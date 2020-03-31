# Pipeline Application Tutorial Guides 

## Admin Guide
A **system administrator** needs to be able to manage the Continuous Integration/ContinuousDeployment (CI/CD) pipeline, and upgrade the application when necessary. Some of the tasks that a system administrator might want to do are listed below.

### Prerequisites 
1. Login details for the development and production IBM cloud environments.
2. Installing the IBM cloud command line interface (CLI): Several of the steps below require using the IBM cloud CLI. Details for installing this can be found [here](https://cloud.ibm.com/docs/cli?topic=cloud-cli-getting-started).
3. Installing Kubectl: This is required to run commands against Kubernetes Clusters. It is required for several of the steps below, and details for how to install it can be found [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

### Trigger a deployment to production
A brief overview of the Continuous Integration portion of our pipeline is as follows: 

There are two main branches, master and develop. We are following a gitflow workflow, so feature branches are cut from  develop, worked on locally and then merged back into develop. Changes to any branch will trigger a deployment of that branch to develop, however only changes to the master branch will trigger a deployment to the production environment. 

As such, whenever one wants to start a deployment to production the steps are as follows:
- Cut a release branch from develop, following the format “Version[Major
change].[Minor change]”.
- Create a Pull Request (PR) to master, which will have to be approved by another
member of the team.
- Creating the release branch will trigger a deployment to develop of that branch, so
before it is merged you can check that it properly deploys to develop.
- Once the PR is approved, merge it to master, triggering a deployment to the
production environment.

### Check the status of the Develop/Production Cloud Registries
The IBM Cloud Registry (CR) service is where we are storing containers of our
application. When using the free tier of this service, there are restrictions on storage (how
many containers we can store) and pull traffic (how many containers we can pull from the
CR). Every time a new deployment is made, the relevant container is pulled from the CR, so
the pull traffic restriction is essentially a limit on deployments per month.

- Log into develop/production CR, depending on which one you’re checking by entering:

```ibmcloud login```

This will require the email and password of the account.
