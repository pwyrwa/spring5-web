## Kubernetes

### Create deployment
NOTE: Make sure image is pushed to the remote repo - can't use local repository

```bash
kubectl create -f deployment.yaml
```



### Create service

```bash
kubectl create -f service.yml

## To see deployment:
kubectl describe service spring5-web
```
* Locally NodePort will be the one showing

Note: minikube runs by default on 192.168.99.100 (ttp://192.168.99.100:<Port>/pio-web/status)

### Logs

```bash
kubectl get pods

kubectl logs <pod> -f 
```

### Deployment (with deployment.yml) - not replicaSet

* Update, push docker with change
* update deployment.yml with new version of docker image

```bash
kubectl apply -f deployment.yml --record
```

* Pods will be different now


TODO: Logs - sidecar container with logs
