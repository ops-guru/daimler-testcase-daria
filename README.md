# Trip analyzer overwiev

This application analyzes vehicle trip data.

## How to deploy infrastructure
Trip analyzer is supposed to be deployed to k8s cluster. We prepared terraform code to roll out environment in yandex cloud. We have a few files which contain keys to access cloud resources and are not included to git repository. 

For simplicity we're assuming that at the moment of cluster deployment network and subnets already exist and we know their IDs. For simplicity and in order to save resources in this example we create a single zone cluster with auto-scalable nodepool (from 1 to 3 nodes).

First of all we have to create service accounts for kubernetes.

```
cd terraform
source env.sh
cd terraform/resources/k8s-sa
terragrunt apply  # make sure plan looks ok, type "yes"
```

After that we can create kubernetes cluster:
```
cd terraform/resources/k8s
terragrunt apply  # make sure plan looks ok, type "yes"
```

When kubernetes cluster is up and running we're ready to deploy trip analyzer.

## How to deploy application

1) Set environment variables

Trip-analyzer uses Google Geocoding API to define city names based on coordinates. You have to get API KEY and provide it to the application via environment variable. You can lean how to get the key [here](https://developers.google.com/maps/documentation/javascript/get-api-key?hl=ru).

You also have to set username and password which will be used to access trip analyzer.

```
GEO_KEY=<google geo ip key>
USER=admin
PASSWORD=opsguru2020
```
2) Test application
```
make test
```

3) Build docker image
```
make docker-build
```

4) Deploy 
```
make docker-run  # locally

make deploy  # or in k8s cluster
```

## Work with application

If you deployed application locally it listens on localhost:8080.

If you deployed to k8s you have to run the following commands to access application (application service doesn't have public IP for security reasons).

```
kubectl get pods  # find running pod with name starting with 'trip-analyzer', for example trip-analyzer-f94555df9-kk9pr

kubectl port-forward <trip-analyzer pod name> 8080
```

After that you can work with application from command line or using UI. 

UI is accessible on [localhost:8080/v1/ui](localhost:8080/v1/ui)

Application is protected with BasicAuth, use specified on the 1st step creds to login via UI or user:password pair encoded in base64 if you're using command line.

## Usage example

Try to call API from command line

```
curl -i -X POST --header "Content-Type: application/json" --header  "Authorization: Basic YWRtaW46b3BzZ3VydTIwMjA=" \
  --data @examples/body.json  \
  http://localhost:8080/v1/trip
```