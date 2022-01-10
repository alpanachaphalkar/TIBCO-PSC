#
# Copyright (c) 2019-2019 TIBCO Software Inc.
# All Rights Reserved. Confidential & Proprietary.
# For more information, please contact:
# TIBCO Software Inc., Palo Alto, California, USA
#

#How to Build the FC docker image  :

#If  you are using the ORACLE as database then create ORACLE driver jboss module
1. Copy the ojdbc driver ojdbc8.jar to JBModules/modules/system/layers/base/com/oracle/main directory.
2. Edit JBModules/modules/system/layers/base/com/oracle/main/module.xml and uncomment the <!--resource-root path="ojdbc8.jar"/--> xml element, specify exact name of jar in path attribute. 

#Create EMS module in JBOSS
1. Copy the tibjms.jar to JBModules/modules/system/layers/base/com/tibco/mdm/main directory.

docker build -t fc:5.0.0 --build-arg MDM_VERSION=9.1.0 --build-arg MDM_MAJOR_VERSION=9.1 --build-arg FC_VERSION=5.0.0 --build-arg FC_MAJOR_VERSION=5.0 --build-arg  MDM_HOTFIX_VERSION=hotfix06  --rm=true .

#How to Run the FC docker image locally  :
docker run -p 8080:8080 -p 6080:6080 -p 8070:8070 imagename


For kubernetes deployment, you need to push image into docker registry :

1. login into docker registry as : 

e.g. :  docker login reldocker.tibco.com

Then login with your credentials

2. Create tag of docker image you want to push into docker registry :

e.g. : docker tag fc:5.0.0 reldocker.tibco.com/<docker user name>/fc:5.0.0

3. Push tagged image into docker registry :

e.g. : docker push reldocker.tibco.com/<docker user name>/fc:5.0.0