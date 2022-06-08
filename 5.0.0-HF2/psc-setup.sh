kubectl create ns psc

cd "C:\Users\ALCH390\GolandProjects\TIBCO-PSC\5.0.0-HF2\helm\psc-ignite"
helm install -n psc psc-ignite -f minikube-values.yaml .

cd "C:\Users\ALCH390\GolandProjects\TIBCO-PSC\5.0.0-HF2\helm\psc"
helm install -n psc psc -f minikube-values.yaml .

minikube tunnel