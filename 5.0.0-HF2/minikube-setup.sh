minikube delete --purge
minikube start --memory 10692 --cpus 4 --driver=docker && minikube addons enable ingress
eval $(minikube docker-env)
docker images
gcloud auth configure-docker
docker pull eu.gcr.io/de-fo-gr-pr-shared/tibco/psc/fc:5.0.0-HF2 && docker pull eu.gcr.io/de-fo-gr-pr-shared/tibco/psc/ignite_p13:5.0.0-HF2