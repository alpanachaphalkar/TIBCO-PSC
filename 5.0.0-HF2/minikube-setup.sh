minikube start --memory 8192 --cpus 4 --driver=docker
minikube addons enable ingress
eval $(minikube docker-env)
docker images
docker pull eu.gcr.io/de-fo-gr-pr-shared/tibco/psc/fc:5.0.0-EB20211012
docker pull eu.gcr.io/de-fo-gr-pr-shared/tibco/psc/ignite:1.9.0-EB20210922