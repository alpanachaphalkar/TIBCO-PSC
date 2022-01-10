#
# Copyright (c) 2019-2019 TIBCO Software Inc.
# All Rights Reserved. Confidential & Proprietary.
# For more information, please contact:
# TIBCO Software Inc., Palo Alto, California, USA
#
# FC POSTGRES DB DOCKERFILES PROJECT
# ---------------------------------------------------------
# This is the Dockerfile for FC postgres database App
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) TIB_mdm-JBOSS-PGRS_9.1.0_linux_x86_64.zip 
#		Download TIB_mdm-JBOSS-PGRS_9.1.0_linux_x86_64.zip from Tibco portal
# (2) TIB_cim-ac_5.0.0_linux_x86_64.zip
#		Download TIB_cim-ac_5.0.0_linux_x86_64.zip from Tibco portal
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ docker build --build-arg MDM_VERSION=9.1.0 --build-arg MDM_MAJOR_VERSION=9.1 --build-arg FC_VERSION=5.0.0 --build-arg FC_MAJOR_VERSION=5.0 -t fcdb:5.0.0 --rm=true .
#
# Pull base image
# ---------------
FROM library/postgres:9.6

MAINTAINER Kameshwar Prasad <kprasad@tibco.com>

ARG USER_HOME=/home/postgres
ARG MDM_VERSION=9.1.0
ARG FC_VERSION=5.0.0
ARG FC_MAJOR_VERSION=5.0
ARG MDM_MAJOR_VERSION=9.1

# Execute system update
RUN apt-get -y update && \
	apt-get install -y locales	&& \
	mkdir -p /tmp/build	&& \
	chmod -R 777 /tmp
	
COPY ["TIB_mdm-JBOSS-PGRS_${MDM_VERSION}_linux_x86_64.zip", "TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip", "/tmp/build/"]

ENV PGHOME /usr/lib/postgresql/$PG_MAJOR

#Create home dir for posgres user and Change ownership so that database can be created
RUN mkdir /home/postgres		&& \
	chown -R postgres:postgres /home/postgres		&& \
	chown -Rv postgres:postgres /var/lib/postgresql	&& \
	chmod -R 744 /var/lib/postgresql


USER root
RUN apt-get install unzip	&& \
	usermod -d ${USER_HOME} -s /bin/sh postgres	&& \
	# bring MDM set up scripts
	echo 'Starting MDM setup now...'

RUN mkdir -p /home/postgres/tmp/build &&\
cd /home/postgres/tmp/build &&\
unzip /tmp/build/TIB_mdm-JBOSS-PGRS_${MDM_VERSION}_linux_x86_64.zip assemblies/product_tibco_cim_executableimage_postgresjboss_*.zip -d /home/postgres/tmp/build &&\
unzip /home/postgres/tmp/build/assemblies/product_tibco_cim_executableimage_postgresjboss_*.zip source/db/postgreSQL/install/* source/db/postgreSQL/configure/* -d /home/postgres/scripts  &&\
unzip /tmp/build/TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip assemblies/product_tibco_cim_ac_${FC_VERSION}.*.zip -d /home/postgres/tmp/build &&\
unzip /home/postgres/tmp/build/assemblies/product_tibco_cim_ac_${FC_VERSION}.*.zip source/db/postgreSQL/install/* -d /home/postgres/scripts_fc &&\
unzip /home/postgres/tmp/build/assemblies/product_tibco_cim_ac_${FC_VERSION}.*.zip source/db/postgreSQL/utility/* -d /home/postgres/scripts_fc &&\
unzip /home/postgres/tmp/build/assemblies/product_tibco_cim_ac_${FC_VERSION}.*.zip source/docker/dependents/fcdb/* -d /home/postgres/scripts_postgres  &&\
chmod -R 744  /home/postgres/scripts_postgres &&\
cp /home/postgres/scripts_postgres/source/docker/dependents/fcdb/scripts/db/postgreSQL/install/pg_init.d.sh /docker-entrypoint-initdb.d/

ENV MQ_HOME /home/postgres/scripts/source

RUN chown -R postgres:postgres /home/postgres/scripts/source	 &&\
	chown -R postgres:postgres /home/postgres/scripts_fc/source	 &&\
	chmod -R 744 /home/postgres/scripts/source	 &&\
	chmod -R 744 /home/postgres/scripts_fc/source

# RUN mkdir /docker-entrypoint-initdb.d
#COPY ./scripts/db/postgreSQL/install/pg_init.d.sh /docker-entrypoint-initdb.d/

RUN chmod -R 744 /docker-entrypoint-initdb.d/* &&\
	rm -rf /tmp/*

ENV PGUSERHOME /home/postgres

EXPOSE 5432
