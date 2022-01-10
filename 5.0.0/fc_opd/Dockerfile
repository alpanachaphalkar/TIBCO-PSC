#
# Copyright (c) 2019-2019 TIBCO Software Inc.
# All Rights Reserved. Confidential & Proprietary.
# For more information, please contact:
# TIBCO Software Inc., Palo Alto, California, USA
#

#
# FC MULTICONTAINER DOCKER PROJECT
# ---------------------------------------------------------
# This is the Dockerfile for FC App
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) TIB_cim-ac_5.0.0_linux_x86_64.zip (download from TIBCO release portal)
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Verify that above files has atleast read permissions to everyone. If not, then change the permission using chmod command.
# Run:
#  docker build -t fcopd:5.0.0 --build-arg FC_VERSION=5.0.0 --build-arg FC_MAJOR_VERSION=5.0 --rm=true .
#
# ---------------

FROM fcbase:latest

MAINTAINER Kameshwar Prasad <kprasad@tibco.com>

ARG USER_HOME=/home/postgres
ARG FC_VERSION=5.0.0
ARG FC_MAJOR_VERSION=5.0

#RUN mkdir -p /tmp/build

USER root

COPY ["TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip","/tmp/build/"]

RUN mkdir /home/postgres && \
	chmod -R 777 /home/postgres && \
	apk --no-cache add shadow && \
	usermod -d ${USER_HOME} -s /bin/sh postgres && \
	apk --no-cache add tzdata libpq libldap libressl2.7-libcrypto libressl2.7-libssl libxml2 musl linux-pam postgresql-contrib postgresql-client rsync && \
	mkdir -p /tmp/build/	&& \
	chmod -R 777 /tmp

ENV HOME ${USER_HOME}
ENV JAVA_HOME=/usr/lib/jvm/default-jvm 
ENV FC_VERSION ${FC_VERSION}
ENV FC_MAJOR_VERSION ${FC_MAJOR_VERSION}


RUN mkdir -p /usr/lib/jvm &&\
	apk -U upgrade && \
	cd /tmp/build &&\
	mkdir -p $HOME/opd && \
    unzip /tmp/build/TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip assemblies/product_tibco_tibcojava64_1.8*_linux_x86_64.zip assemblies/product_tibco_cim_ac_OPD_*.zip -d /tmp/build/ && \
	unzip /tmp/build/assemblies/product_tibco_tibcojava64_1.8*_linux_x86_64.zip source/* -d /usr/lib/jvm && \
	mv "/usr/lib/jvm/source" "/usr/lib/jvm/java-${JAVA_VERSION_MAJOR}" && \
	ln -s /usr/lib/jvm/java-${JAVA_VERSION_MAJOR} /usr/lib/jvm/default-jvm && \
    ln -s /usr/lib/jvm/java-${JAVA_VERSION_MAJOR}/bin/java /usr/bin/java && \
    ln -s /usr/lib/jvm/java-${JAVA_VERSION_MAJOR}/bin/javac /usr/bin/javac && \
	chmod -R 755 /usr/lib/jvm && \
	unzip /tmp/build/assemblies/product_tibco_cim_ac_OPD_*.zip source/* -d $HOME/opd && \
	chmod 777 -R $HOME/opd && \
	rm -rf /tmp/*

WORKDIR $HOME
USER postgres
EXPOSE 8070

ENTRYPOINT ["java","-Dfc.host=${FC_SERVICE_HOST}","-Dfc.port=${FC_SERVICE_PORT}","-Dapp.DataVolume=${OPD_APP_DATA_VOLUME}","-Dspring.profiles.active=prod","-jar","/home/postgres/opd/source/opdesigner.war"]
