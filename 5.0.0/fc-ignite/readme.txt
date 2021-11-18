#
# Copyright (c) 2019-2019 TIBCO Software Inc.
# All Rights Reserved. Confidential & Proprietary.
# For more information, please contact:
# TIBCO Software Inc., Palo Alto, California, USA
#


Instructions on how to build the Ignite docker container.
-----------------------------------------------------------
1. If database is ORACLE then copy the database driver into the jars folder.

2. Make sure that you have the fcignitebase:latest docker image built.

3. Build the docker image using the command
docker build -t ignite:1.9.0.latest --build-arg MDM_VERSION=9.1.0 --build-arg FC_VERSION=5.0.0 --rm=true .

# to run this image, following command can be used. 

a. For POSTGRES database
   docker run -d --name=ignite1.9.0 -e POSTGRES_PASSWORD=postgres -e MQ_MDM_DB_HOST=<fc database Host> -e MQ_MDM_DB_PORT=<fc database Port> -e MQ_MDM_DB_USER=<fc database user> -e MQ_MDM_DB_USER_PWD=<fc database password> -e MQ_MDM_DB_NAME=<fc database name> -e MQ_MDM_DB_TYPE=POSTGRES -p 47500-47510:47500-47510 ignite:1.9.0.latest

b. For ORACLE database 
   docker run -d --name=ignite1.9.0 -e MQ_MDM_DB_HOST=<fc database Host> -e MQ_MDM_DB_PORT=<fc database Port> -e MQ_MDM_DB_USER=<fc database user> -e MQ_MDM_DB_USER_PWD=<fc database password> -e MQ_MDM_DB_NAME=<fc database name> -e MQ_MDM_DB_TYPE=ORACLE -p 47500-47510:47500-47510 ignite:1.9.0.latest
