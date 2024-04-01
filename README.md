# Setup Minikube Cluser on EC2 machine and run Redis Cluser using helm - using userdata to install Docker, Minikube, kubectl and Helm
- This document describe a steps on how to setup minikube cluster on EC2 and run Redis cluser using Helm chart.
## Prerequisites
- Install AWS CLI - (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Setup AWS credentails using 
```
aws configure
```
- if you would like to use different profile use following command to set default profile.
```
export AWS_DEFAULT_PROFILE=<profiel name>
```
## Download code from the following repo
```
git clone -b main https://github.com/amarsingh3d/redis.git
```
## Create EC2 machine
- To create EC2 machine run following commands.
- Switch to terraform directory and replace following variables.

```
cd redis/terraform

```

- update variable cidr_blocks with your IP so we can do ssh to machine.
```
variable "cidr_blocks" {
  default = "103.69.14.12/32"

}

```
- Update public key for SSH
```
variable "pub_key" {
  description = "Minikube pub key"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPNmt"

}
```
- Run Terraform  init, plan and apply
```
terraform init \
terraform fmt \
terraform validate
```
```
terraform plan
```
```
terraform apply
```

- Take a note of output of public IP

### Create Redis Cluster and Redis client POD
- SSH to EC2 machine
```
ssh -i <path of you private key> ubuntu@<server_IP>
```
- take a clone of git repository on the server
```
git clone -b main https://github.com/amarsingh3d/redis.git
```
- Switch to correct directory
```
cd redis/helm
```
- Start minikube cluster
```
minikube start
```
- varify minikube status
```
minikube status
```
- Create Redis cluster
```
helm install redis-cluster redis-cluster/ -f redis-cluster/values.yaml
```
- Create redis client
```
helm install redis-client redis-client/ -f redis-client/values.yaml
```
- Get pod details and make sure all pod are up and running
```
kubectl get pod
```
- get the redis cluster auth password
```
export REDIS_PASSWORD=$(kubectl get secret --namespace default redis-cluster -o jsonpath="{.data.redis-password}" | base64 -d)
echo $REDIS_PASSWORD
```
- connect redis-client pod and create redis key
```
kubectl get pod
```
Take  a node of redis-client POD name
- connect redis client pod
```
kubectl exec --tty -i < redis client pod name here > -c redis-client /bin/bash
```
- Connect redis master
```
redis-cli -h redis-cluster-master
```
- authorize usign password, replace password from above 3rd last steps
```
auth <passwrod >
```
- Test redis using ping command output should be Pong
```
ping
```
- Create new key
```
set OxKey OxValue
```
- get newlly added key
```
get OxKey
```

## If output is expected everything is up and running as expected.

