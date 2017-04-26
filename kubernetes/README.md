## Kubernetes

### Create deployment

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

Note: minikube runs by default on 192.168.99.100

TODO: Logs, volumes, etc....
