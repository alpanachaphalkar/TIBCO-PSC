#
# Copyright (c) 2019-2022 TIBCO Software Inc.
# All Rights Reserved. Confidential & Proprietary.
# For more information, please contact:
# TIBCO Software Inc., Palo Alto, California, USA
#

#
# FC MULTICONTAINER DOCKER PROJECT
# ---------------------------------------------------------
# This is the Dockerfile for hotfix of FC App
#
# REQUIRED FILES TO BUILD UPON THE 500GA IMAGE
# ------------------------------------------

# (1)TIB_CIM.9.1.2_JBOSSORA_hotfix02.tar (download from TIBCO release portal)
# (2)TIB_cim-ac_5.0.0_hotfix002.tar (download from TIBCO release portal)

#
# If  you are using the ORACLE as database then create ORACLE driver jboss module
#       1. Copy the ojdbc driver ojdbc*.jar to JBModules/modules/system/layers/base/com/oracle/main directory.
#       2. Edit JBModules/modules/system/layers/base/com/oracle/main/module.xml and uncomment the <!--resource-root path="ojdbc8.jar"/--> xml element, specify exact name #      of jar in path attribute.
# Create EMS module in JBOSS
#       1. Copy the tibjms.jar to JBModules/modules/system/layers/base/com/tibco/mdm/main directory.
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Verify that above files has atleast read permissions to everyone. If not, then change the permission using chmod command.
# Verify that entry-point.sh has execute permissions. If not, then change the permission using chmod command.
# Run:
#  docker build -t fc:5.0.0.hf2 --build-arg MDM_VERSION=9.1.2 --build-arg MDM_MAJOR_VERSION=9.1 --build-arg FC_VERSION=5.0.0 --build-arg FC_MAJOR_VERSION=5.0 --build-arg  MDM_HOTFIX_VERSION=hotfix02 --build-arg FC_HOTFIX_VERSION=hotfix002 --rm=true .
#
# ---------------

FROM registry.cloud.okteto.net/psc-alpanachaphalkar/tibco-psc-fc:okteto

MAINTAINER Kameshwar Prasad <kprasad@tibco.com>

ARG USER_HOME=/home/postgres
ARG MDM_VERSION=9.1.2
ARG FC_VERSION=5.0.0
ARG FC_MAJOR_VERSION=5.0
ARG MQ_ON_TROPOS=true
ARG MDM_MAJOR_VERSION=9.1
ARG MDM_HOTFIX_VERSION=hotfix02
ARG FC_HOTFIX_VERSION=hotfix002



RUN mkdir -p /tmp/build

USER postgres

ENV MQ_HOME ${USER_HOME}/tibco/mdm/${MDM_MAJOR_VERSION}
ENV HOME ${USER_HOME}
ENV JAVA_HOME /home/postgres/tibco/tibcojre64/1.8.0
ENV MDM_MAJOR_VERSION ${MDM_MAJOR_VERSION}
ENV MDM_VERSION ${MDM_VERSION}
ENV MQ_COMMON_DIR $MQ_HOME/common
ENV JBOSS_HOME $MQ_HOME/bin/wildfly-10.1.0.Final
ENV TPATH $JAVA_HOME/bin:$PATH
ENV JDK_HOME=$HOME/jarutil
ENV PATH $JAVA_HOME/bin:$JDK_HOME/bin:$PATH
ENV AC_HOME $MQ_HOME/plugins/ac/${FC_MAJOR_VERSION}
ENV FC_VERSION ${FC_VERSION}
ENV FC_MAJOR_VERSION ${FC_MAJOR_VERSION}
ENV MQ_ON_TROPOS $MQ_ON_TROPOS
ENV MDM_HOTFIX_VERSION $MDM_HOTFIX_VERSION
ENV FC_HOTFIX_VERSION $FC_HOTFIX_VERSION
ENV FC_MULTI_DEPLOY true

USER root

RUN gdown --id 1UOAqqq2YFFruzfBaWzmPkep8EKHq4ZGg --output TIB_CIM.9.1.2_JBOSSORA_hotfix02.tar \
    && gdown --id 1xw8cG6Do2SUcSZZLmGcwUGk2rJN8ZxV_ --output TIB_cim-ac_5.0.0_hotfix002.tar

COPY ["entry-point.sh", "TIB_CIM.9.1.2_JBOSSORA_hotfix02.tar", "TIB_cim-ac_5.0.0_hotfix002.tar","/tmp/build/"]

USER postgres

RUN mkdir -p $HOME/tmp/build && \
    cd $HOME/tmp/build && \
	cp ${MQ_HOME}/customEAR/ECM.ear $MQ_HOME && \
	rm -rf ${MQ_HOME}/customEAR/* && \
	tar -xvf /tmp/build/TIB_CIM.9.1.2_JBOSSORA_hotfix02.tar -C ${MQ_HOME}/customEAR && \
	 cd ${MQ_HOME}/customEAR && \
	echo 'export JAVA_HOME=$JDK_HOME ' >> applyHotFixInDocker.sh && \
        echo './customUtil.sh -updateEarFile <<! '  >>applyHotFixInDocker.sh && \
        echo 'Y '  >>applyHotFixInDocker.sh && \
        echo 'TIB_CIM.9.1.2_hotfix02.jar' >>applyHotFixInDocker.sh && \
    echo '!'  >>applyHotFixInDocker.sh && \
	echo './customUtil.sh -createCommonHotfixLibrary <<! '  >>applyHotFixInDocker.sh && \
       echo '$MQ_HOME/customEAR/TIB_CIM.9.1.2_hotfix02.jar' >>applyHotFixInDocker.sh && \
	    echo 'Y '  >>applyHotFixInDocker.sh && \
        echo '!'  >>applyHotFixInDocker.sh && \
        chmod -R 0700 ${MQ_HOME}/customEAR && \
        ./applyHotFixInDocker.sh && \
	cp ${MQ_HOME}/customEAR/ECM.ear $MQ_HOME && \
	cp ${MQ_HOME}/customEAR/version.properties $MQ_HOME && \
	rm -rf ${MQ_HOME}/customEAR/* && \
	tar -xvf /tmp/build/TIB_cim-ac_5.0.0_hotfix002.tar -C ${MQ_HOME}/customEAR && \
	cd ${MQ_HOME}/customEAR && \
	tar -xvf ac_5.0.0_hotfix002.tar -C ${MQ_HOME}/customEAR && \
	cd ${MQ_HOME}/customEAR/ac/5.0/bin && \
	echo './ApplyHotFix.sh <<! '  >>applyHotFixInDocker1.sh && \
	echo '!'  >>applyHotFixInDocker1.sh && \
	chmod -R 0700 ${MQ_HOME}/customEAR/ac/5.0/ && \
	./applyHotFixInDocker1.sh
	
WORKDIR $HOME
ENV PATH $TPATH

# Add VOLUMEs to allow backup of MQ_COMMON, MQ_CONFIG , DATABASE
VOLUME ["${MQ_HOME}/bin/pgsql/data", "${MQ_HOME}/bin/pgsql/tablespaces", "${MQ_HOME}/common", "${MQ_HOME}/config"]

EXPOSE 8080 6080 8070 5432 47500 47501 47502 47503 47504 47505 47506 47507 47508 47509 47510 8010 9990 7600 8888

ENTRYPOINT ["/home/postgres/tibco/mdm/entry-point.sh"]

CMD ["/home/postgres/tibco/mdm/9.1/bin/wildfly-10.1.0.Final/bin/StartMDMServer.sh"]
