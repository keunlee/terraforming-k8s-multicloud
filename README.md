# Terraforming Kubernetes for Multicloud

## Creating Clusters with Terraform

This project aims to provide sample terraform scripts to build up K8S clusters in the following cloud environments: 

* Azure 
* Google Cloud

You will find respective terraform scripts that may aid you in this endeavor

w/in each respective terraform directory: 

make sure to adjust your environment as necessary, depending on the cloud environment you are terraforming. 

run the following to build up your infrastructure

```
terraform init
terraform plan
terraform apply
```

# Multicloud Cluster Registraion - Google Anthos

Once you have created your clusters in your infrastructure(s) you can then register them into Google Anthos.

## Registering GKE Clusters with Anthos

execute the following script from the scripts directory: 

```
source register-gke-cluster.sh
```

make sure that all the variables have been supplied before responding "yes" (`1`)

## Registering non-GKE clusters with Anthos

(1) register your cluster with Anthos

execute the following script from the scripts directory: 

```
source register-non-gke-cluster.sh
```

make sure that all the variables have been supplied before responding "yes" (`1`)

(2) setup your cluster so that you'll be able to login into from your anthos dashboard. 


execute the following script from the scripts directory: 

```
source setup-anthos-cloud-console-login.sh
```

make sure that all the variables have been supplied before responding "yes" (`1`)

after it has executed, copy the token value, and use that to login into the cluster from the Anthos dashboard. 