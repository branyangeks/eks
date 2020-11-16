#! /usr/sh

# Use the profile which has IAM rights
export AWS_PROFILE=eks
echo "Using AWS profile: $AWS_PROFILE"

export AWS_REGION=us-east-1
echo "Using AWS region: $AWS_REGION"

export K8S_VERSION=1.18
echo "Using Kubernetes versoin: $K8S_VERSION"

# Check any existing EKS cluster
eksctl get cluster \
  --profile $AWS_PROFILE \
  --region $AWS_REGION

# use profile "eks" and region "us-east-1" 
# use matching kubectl version e.g. 1.18
#     Refer: https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
eksctl create cluster \
  --profile $AWS_PROFILE \
  --region $AWS_REGION \
  --name tricentis-cluster \
  --version $K8S_VERSION \
  --nodegroup-name standard-workers \
  --node-type t3.micro \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 4 \
  --node-ami auto

# After 10 min or so, confirm again for desired EKS cluster
eksctl get cluster \
  --profile $AWS_PROFILE \
  --region $AWS_REGION

# Typically the config file would be stored as
#    ~/.kube/config

# Get the info of K8s cluster e.g. cluster IP
kubectl get svc
# Get the info of K8s nodes
kubectl get nodes

# Generate secret for MySQL db
kubectl create secret generic mysql-pass --from-literal=password=<your-secret-password-here>
# Confirm the secret configuration
kubectl get secrets

# YAML files for pods : 
curl https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/wordpress/mysql-deployment.yaml > mysql-deployment.yaml
curl https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/wordpress/wordpress-deployment.yaml > wordpress-deployment.yaml

### === MySQL pod === ###
# Create MySQL pod
kubectl create -f mysql-deployment.yaml
# Confirm the data volume
kubectl get pvc
# Confirm the pod itself
kubectl get pods

### === WordPress pod === ###
#  WordPress pod
kubectl create -f wordpress-deployment.yaml
# Confirm!
kubectl get pvc
kubectl get pods

# Check the services
kubectl get services 
# OR use : kubectl get services --all-namespaces -o wide
kubectl get service wordpress # Notice that the Load Balancer is setup