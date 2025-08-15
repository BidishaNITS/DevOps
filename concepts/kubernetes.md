# Kubernetes —  (Minikube + Deploy + Service)

## Aim 
Run my Dockerized Flask app on a local Kubernetes cluster using **Minikube**, and reach it from the browser.

---

## What I actually did
1) **Started a local cluster** with Minikube (Docker driver, 2 CPU, 4 GB RAM).  
2) **Built the Docker image** and **made it available** to Minikube.  
3) **Applied** two manifests:
   - `Deployment` (runs/keeps my app pod)
   - `Service (NodePort)` (opens a fixed port so I can access the app)
4) **Opened the app** via `minikube service`.

---

## Files I used (only these)
- `k8s/deployment.yaml` → defines the app container (image `app:1.0`) and runs 1 replica
- `k8s/service.yaml` → exposes the app on a node port  

---

## Commands I ran 
```bash
# 1) Start local cluster
minikube start --driver=docker --cpus=2 --memory=4096
kubectl config use-context minikube
kubectl get nodes    # should show Ready

# 2) Build image and load into Minikube
docker build -t app:1.0 .
minikube image load app:1.0

# 3) Apply manifests
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl get pods
kubectl get svc

# 4) Open the app
minikube service app-service



Minimal concepts to remember
	•	Pod: the running unit (contains your container).
	•	Deployment: keeps the desired number of pods running (today = 1).
	•	Service (NodePort): gives a stable way to reach pods from outside the cluster.
	•	Minikube: runs Kubernetes locally on my laptop (no cloud needed).

Why NodePort?
It’s the simplest way on Minikube to expose the app on <minikube ip>:<nodePort>.

⸻

Troubleshooting I hit (and fixes)
	•	kubectl couldn’t connect / wrong port →
Run:

minikube update-context
minikube start


	•	kubelet / apiserver stopped →
Restart with more resources:

minikube stop
minikube start --driver=docker --cpus=2 --memory=4096


	•	Port 5000 busy on Docker run (earlier) →
Map to a different host port:

docker run -p 8080:5000 app:1.0



