#
# Copyright (c) 2019-2019 TIBCO Software Inc.
# All Rights Reserved. Confidential & Proprietary.
# For more information, please contact:
# TIBCO Software Inc., Palo Alto, California, USA
#

#
# FC Ignite DOCKERFILES PROJECT
# ---------------------------------------------------------
# This is the Dockerfile for FC Ignite  App
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) TIB_mdm-JBOSS-PGRS_9.1.0_linux_x86_64.zip 
#		Download TIB_mdm-JBOSS-PGRS_9.1.0_linux_x86_64.zip from Tibco portal
# (2) TIB_cim-ac_5.0.0_linux_x86_64.zip
#		Download TIB_cim-ac_5.0.0_linux_x86_64.zip from Tibco portal
# (3) apache-ignite-fabric-1.9.0-bin.zip
#       Download apache-ignite-fabric-1.9.0-bin.zip from apache download portal.
#
#
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# 1. If database is ORACLE then copy the database driver into the jars folder.
# 2. Make sure that you have the fcignitebase:latest docker image built.
# 3. Build the docker image using the command
#	Run: 
#      $ docker build -t ignite_p13:1.9.0.latest --build-arg MDM_VERSION=9.1.0 --build-arg FC_VERSION=5.0.0 --rm=true .
#
# Pull base image
# ---------------

FROM fcignitebase:latest

MAINTAINER Manav Garg<mangarg@tibco.com>

ARG USER_HOME=/home/igniteuser
ARG MDM_VERSION=9.1.0
ARG FC_VERSION=5.0.0

ENV HOME ${USER_HOME}

USER root

RUN adduser igniteuser && \
    mkdir -p /tmp/build/

COPY ["TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip","TIB_mdm-JBOSS-PGRS_${MDM_VERSION}_linux_x86_64.zip","entry-point.sh","apache-ignite-fabric-1.9.0-bin.zip","jars","/tmp/build/"]

RUN chmod -R 777 /tmp

USER igniteuser

RUN cd /tmp/build && \
	unzip /tmp/build/TIB_mdm-JBOSS-PGRS_${MDM_VERSION}_linux_x86_64.zip assemblies/product_tibco_cim_executableimage_postgresjboss_*.zip -d /tmp/build/ &&\
	unzip /tmp/build/assemblies/product_tibco_cim_executableimage_postgresjboss_*.zip source/lib/mq/ECMClasses.jar  -d  /tmp/build/  &&\
    unzip /tmp/build/TIB_mdm-JBOSS-PGRS_${MDM_VERSION}_linux_x86_64.zip assemblies/product_tibco_postgresql_driver_*.zip -d /tmp/build/ &&\
	unzip /tmp/build/assemblies/product_tibco_postgresql_driver_*.zip source/postgresql-*.jar  -d  /tmp/build/  &&\
	unzip /tmp/build/TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip assemblies/product_tibco_cim_ac_${FC_VERSION}.*.zip -d /tmp/build/ &&\
	unzip /tmp/build/assemblies/product_tibco_cim_ac_${FC_VERSION}.*.zip source/docker/dependents/fc-ignite/* -d /tmp/build/ &&\
	unzip /tmp/build/apache-ignite-fabric-1.9.0-bin.zip -d $HOME && \
    cp /tmp/build/source/lib/mq/ECMClasses.jar $HOME/apache-ignite-fabric-1.9.0-bin/libs && \
	cp /tmp/build/source/postgresql-*.jar $HOME/apache-ignite-fabric-1.9.0-bin/libs && \
	cp -r /$HOME/apache-ignite-fabric-1.9.0-bin/libs/optional/ignite-rest-http $HOME/apache-ignite-fabric-1.9.0-bin/libs && \
    if [ -e *.jar ] ; then cp /tmp/build/*.jar $HOME/apache-ignite-fabric-1.9.0-bin/libs ; fi && \
    cp /tmp/build/entry-point.sh $HOME && \
    cp /tmp/build/source/docker/dependents/fc-ignite/default-config.xml $HOME/apache-ignite-fabric-1.9.0-bin/config && \
    cp /tmp/build/source/docker/dependents/fc-ignite/ignite-log4j.xml $HOME/apache-ignite-fabric-1.9.0-bin/config && \
    cp $HOME/apache-ignite-fabric-1.9.0-bin/libs/optional/ignite-log4j/*.jar $HOME/apache-ignite-fabric-1.9.0-bin/libs && \
    mkdir -p $HOME/apache-ignite-fabric-1.9.0-bin/logs && \
    echo "#!/bin/bash" > $HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh && \
    echo "if [ \"\${MQ_MDM_DB_TYPE}\" == \"POSTGRES\" ]" >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh && \
    echo "then " >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh && \
    echo "    sed -i 's/POSTGRES_DATASOURCE_BEGIN/POSTGRES_DATASOURCE_BEGIN-->/' \$HOME/apache-ignite-fabric-1.9.0-bin/config/default-config.xml" >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh && \
    echo "    sed -i 's/POSTGRES_DATASOURCE_END/<!--POSTGRES_DATASOURCE_END/' \$HOME/apache-ignite-fabric-1.9.0-bin/config/default-config.xml" >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh && \
    echo "else ">> $HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh && \
    echo "    sed -i 's/postgres-ds/oracle-ds/' \$HOME/apache-ignite-fabric-1.9.0-bin/config/default-config.xml" >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh && \
    echo "    sed -i 's/ORACLE_DATASOURCE_BEGIN/ORACLE_DATASOURCE_BEGIN-->/' \$HOME/apache-ignite-fabric-1.9.0-bin/config/default-config.xml" >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh && \
    echo "    sed -i 's/ORACLE_DATASOURCE_END/<!--ORACLE_DATASOURCE_END/' \$HOME/apache-ignite-fabric-1.9.0-bin/config/default-config.xml" >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh && \
    echo "fi" >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh && \
    echo "#!/bin/bash" > $HOME/apache-ignite-fabric-1.9.0-bin/bin/startIgnite.sh && \
    echo "cd \$HOME/apache-ignite-fabric-1.9.0-bin/bin" >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/startIgnite.sh && \
    echo "\$HOME/apache-ignite-fabric-1.9.0-bin/bin/updateIgniteConf.sh" >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/startIgnite.sh && \    
    echo "\$HOME/apache-ignite-fabric-1.9.0-bin/bin/ignite.sh" >> $HOME/apache-ignite-fabric-1.9.0-bin/bin/startIgnite.sh && \
    chmod -R 777 $HOME/apache-ignite-fabric-1.9.0-bin/bin && \
    export INGNITE_HOME=/home/igniteuser/apache-ignite-fabric-1.9.0-bin && \
    rm -rf /tmp/build
             
EXPOSE 47500 47501 47502 47503 47504 47505 47506 47507 47508 47509 47510

WORKDIR ${USER_HOME}

ENTRYPOINT ["/home/igniteuser/entry-point.sh"]

CMD ["/home/igniteuser/apache-ignite-fabric-1.9.0-bin/bin/startIgnite.sh"]
