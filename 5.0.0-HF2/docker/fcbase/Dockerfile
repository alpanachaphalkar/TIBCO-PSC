#
# Copyright (c) 2019-2019 TIBCO Software Inc.
# All Rights Reserved. Confidential & Proprietary.
# For more information, please contact:
# TIBCO Software Inc., Palo Alto, California, USA
#

#
# FC BASE DOCKERFILES PROJECT
# ---------------------------------------------------------
# This is the Dockerfile for FC BASE Docker Image
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run: 
#      $ docker build -t fcbase:latest --rm=true .
#
# Pull base image
# ---------------

FROM registry.access.redhat.com/ubi7

# Maintainer
# ----------
#MAINTAINER Arun Singh <arusingh@tibco.com>

ARG USER_HOME=/home/tibco
ARG ANT_CONTRIB_VERSION=1.0b3
#ARG ANT_VERSION=1.10.7
ARG ANT_VERSION=1.10.12
#other ENV

ENV ANT_HOME=/etc/ant-${ANT_VERSION} \
    #GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc \
    #GLIBC_VERSION=2.27-r0 \
    #LANG=C.UTF-8 \
    HOME=${USER_HOME}

ENV PATH=${ANT_HOME}/bin:${PATH}
RUN useradd -U tibco

RUN set -ex; yum clean all && yum -y update \
    && yum -y install wget unzip zip nc openssl rsync gettext gcc \
    && cd /tmp \
    #&& curl -sS -o apache-ant-${ANT_VERSION}-bin.tar.gz http://www.us.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && wget http://www.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && mkdir ant-${ANT_VERSION} \
    && tar -zxvf apache-ant-${ANT_VERSION}-bin.tar.gz \
    && mv apache-ant-${ANT_VERSION} ${ANT_HOME} \
    && rm apache-ant-${ANT_VERSION}-bin.tar.gz \
    && rm -rf ant-${ANT_VERSION} \
    && rm -rf ${ANT_HOME}/manual \
    && unset ANT_VERSION \
    && cd /tmp \
    #&& curl -sS -o ant-contrib-${ANT_CONTRIB_VERSION}-bin.zip https://sourceforge.net/projects/ant-contrib/files/ant-contrib/${ANT_CONTRIB_VERSION}/ant-contrib-${ANT_CONTRIB_VERSION}-bin.zip \
    && wget https://sourceforge.net/projects/ant-contrib/files/ant-contrib/${ANT_CONTRIB_VERSION}/ant-contrib-${ANT_CONTRIB_VERSION}-bin.zip \
    && unzip ant-contrib-${ANT_CONTRIB_VERSION}-bin.zip -d /tmp/ \
    && cp ant-contrib/ant-contrib-${ANT_CONTRIB_VERSION}.jar ${ANT_HOME}/lib/ant-contrib.jar \
    && rm -rf ant-contrib \
    && rm ant-contrib-${ANT_CONTRIB_VERSION}-bin.zip \
    && unset ANT_CONTRIB_VERSION

RUN cd /opt && wget https://www.python.org/ftp/python/3.8.12/Python-3.8.12.tgz \
    && tar xzf Python-3.8.12.tgz && cd Python-3.8.12 \
    && ./configure --enable-optimizations && make altinstall \
    && rm Python-3.8.12.tgz && python3.8 -V

USER tibco
WORKDIR ${USER_HOME}
# EOF
