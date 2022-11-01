#
# Copyright (c) 2019-2022 TIBCO Software Inc.
# All Rights Reserved. Confidential & Proprietary.
# For more information, please contact:
# TIBCO Software Inc., Palo Alto, California, USA
#

# This is the Dockerfile for PSC hotfix
#
# REQUIRED FILES TO BUILD UPON THE 500GA IMAGE
# ------------------------------------------

# (1)TIB_CIM.9.1.2_JBOSSORA_hotfix02.tar (download from TIBCO release portal)
# (2)TIB_cim-ac_5.0.0_hotfix002.tar (download from TIBCO release portal)

# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Verify that above files has atleast read permissions to everyone. If not, then change the permission using chmod command.
# Verify that entry-point.sh has execute permissions. If not, then change the permission using chmod command.

#How to Build the FC hotfix docker image  :

docker build -t fc:5.0.0.hf2 --build-arg MDM_VERSION=9.1.2 --build-arg MDM_MAJOR_VERSION=9.1 --build-arg FC_VERSION=5.0.0 --build-arg FC_MAJOR_VERSION=5.0 --build-arg  MDM_HOTFIX_VERSION=hotfix02 --build-arg FC_HOTFIX_VERSION=hotfix002 --rm=true .
#########################################################################################################
Important Notes:

1) While using Ingress with https please add and enable FC_SERVICE_FLAG=True and set the WEB_URL_HOST=http://10.197.10.1:9080 <host://ip:port or dns>, FC_SERVICE_HOST=<fc-service-name/fc-service-ip> in configmap / fc-properties.properties
2) Use the docker file in Docker_PSC_hotfix/Ignite folder to create the latest ignite image with readiness probe.
3) Use the latest fc.json and ignite.json provided in Docker_PSC_hotfix folder for enabling readiness and liveness probe.
4) While applying the hotfix on ALLINONE container make sure you make MQ_ON_TROPOS and FC_MULTI_DEPLOY flag as false.
5) For using Helm chart deployment follow the readme provided in Helmchart folder.
6) For installing postgres on GCP follow the readme steps provided in PSC_DB_Postgres_GCP folder
7) For using Postgresql-13 db, update the postgresql jar and modules.xml file in JBModule folder. Same changes are required to be made in dockerfile while building the image (modules\system\layers\base\org\postgresql\main)
8) For using ignite image with Postgresql-13 copy the postgresql jar in ignite lib folder. Same changes are required to be made in dockerfile while building the image.

###########################################################################################################
#How to Run the FC hotfix docker image locally  :
docker run -p 8080:8080 -p 6080:6080 -p 8070:8070 imagename


For kubernetes deployment, you need to push image into docker registry :

1. login into docker registry as : 

e.g. :  docker login reldocker.tibco.com

Then login with your credentials

2. Create tag of docker image you want to push into docker registry :

e.g. : docker tag fc:5.0.0.hf2 reldocker.tibco.com/<docker user name>/fc:5.0.0.hf2

3. Push tagged image into docker registry :

e.g. : docker push reldocker.tibco.com/<docker user name>/fc:5.0.0.hf2