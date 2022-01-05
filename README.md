# TIBCO PSC AC_HOME SAMPLES DATA
Inside Bastion Host

```
mkdir samples
cd samples
kubectl -n psc cp psc-deployment-6fd46bc46-l88xc:home/postgres/tibco/mdm/9.1/plugins/ac/5.0/samples .
```

Then on local system,
```
gcloud compute scp --recurse de-fo-ce-vm-bastion-tibco:/home/ALCH390/samples .
```