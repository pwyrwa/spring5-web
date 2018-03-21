## Kubernetes


### Minikube setup (one time only)

 * https://gist.github.com/kevin-smets/b91a34cea662d0c523968472a81788f7
 
### Do this every time 
 * Run this: `eval $(minikube docker-env)`

### Config map
* Create config map from override-qa.properties

```bash
kubectl create configmap spring5-web-config --from-file=override-qa.properties
```

### Create deployment
NOTE: Make sure image is pushed to the remote repo - can't use local repository

```bash
kubectl create -f deployment.yaml
```
# Deployment resources
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

### Create service

```bash
kubectl create -f service.yml

## To see deployment:
kubectl describe service spring5-web
```
* Locally NodePort will be the one showing

Note: minikube runs by default on 192.168.99.100 (http://192.168.99.100:<Port>/healthcheckc)

### Logs

```bash
kubectl get pods

kubectl logs <pod> -f 
```

### Deployment (with deployment.yml) - not replicaSet

* Update, push docker with change or update config map
* update deployment.yaml with new version of docker image

```bash
kubectl apply -f deployment.yaml --record
```

* Pods will be different now

### Update configuration and deployment

* Create config map from override-qa.properties with updated properties


* Update config map

 - Change value for sample.data in properties to something specific


```bash
kubectl create configmap spring5-web-config-v1 --from-file=override-qa.properties

kubectl edit deployment spring5-web-deployment --record

## Update configmap value and save file

```

* verify property shows up in status page


TODO: Logs - sidecar container with logs


