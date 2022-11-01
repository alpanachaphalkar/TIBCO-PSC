#
# Copyright (c) 2019-2019 TIBCO Software Inc.
# All Rights Reserved. Confidential & Proprietary.
# For more information, please contact:
# TIBCO Software Inc., Palo Alto, California, USA
#

#
# FC BASE DOCKERFILES PROJECT
# ---------------------------------------------------------
# This is the Dockerfile for FC IGNITE BASE Docker Image
# 
#REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) TIB_cim-ac_5.0.0_linux_x86_64.zip
#		Download TIB_cim-ac_5.0.0_linux_x86_64.zip from Tibco portal	
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# 1. Put all downloaded files in the same directory as this Dockerfile
#
# 2. Make sure that you have the fcbase:latest docker image built.
#
# 3. Run: 
#      $ docker build -t fcignitebase:latest --rm=true .
#
# Pull base image
# ---------------

FROM fcbase:latest

# Maintainer
# ----------
#MAINTAINER Nikhil Borpe <nborpe@tibco.com>

ARG FC_VERSION=5.0.0
ARG JAVA_VERSION_MAJOR=1.8.0
ARG USER_HOME=/home/tibco

RUN gdown --id 11a1dmw_-yXrnWHis9hpdSMT1PWwooBLj --output TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip
COPY TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip /tmp/build/

ENV JAVA_HOME=/usr/lib/jvm/default-jvm 

USER root

RUN set -ex; mkdir -p /usr/lib/jvm \
    && yum -y update \
    && cd /tmp/build \
    && unzip /tmp/build/TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip assemblies/product_tibco_tibcojava64_1.8*_linux_x86_64.zip -d /tmp/build/ \
    && unzip /tmp/build/assemblies/product_tibco_tibcojava64_1.8*_linux_x86_64.zip source/* -d /usr/lib/jvm \
    && mv "/usr/lib/jvm/source" "/usr/lib/jvm/java-${JAVA_VERSION_MAJOR}" \
    && ln -s /usr/lib/jvm/java-${JAVA_VERSION_MAJOR} /usr/lib/jvm/default-jvm \
    && ln -s /usr/lib/jvm/java-${JAVA_VERSION_MAJOR}/bin/java /usr/bin/java \
    && ln -s /usr/lib/jvm/java-${JAVA_VERSION_MAJOR}/bin/javac /usr/bin/javac \
    && chmod -R 755 /usr/lib/jvm \
    && rm -rf /tmp/build \
    && rm -rf "$JAVA_HOME/"*src.zip \
    && rm -rf "$JAVA_HOME/lib/missioncontrol" \
           "$JAVA_HOME/lib/visualvm" \
           "$JAVA_HOME/lib/"*javafx* \
           "$JAVA_HOME/jre/lib/plugin.jar" \
           "$JAVA_HOME/jre/lib/ext/jfxrt.jar" \
           "$JAVA_HOME/jre/bin/javaws" \
           "$JAVA_HOME/jre/lib/javaws.jar" \
           "$JAVA_HOME/jre/lib/desktop" \
           "$JAVA_HOME/jre/plugin" \
           "$JAVA_HOME/jre/lib/"deploy* \
           "$JAVA_HOME/jre/lib/"*javafx* \
           "$JAVA_HOME/jre/lib/"*jfx* \
           "$JAVA_HOME/jre/lib/amd64/libdecora_sse.so" \
           "$JAVA_HOME/jre/lib/amd64/"libprism_*.so \
           "$JAVA_HOME/jre/lib/amd64/libfxplugins.so" \
           "$JAVA_HOME/jre/lib/amd64/libglass.so" \
           "$JAVA_HOME/jre/lib/amd64/libgstreamer-lite.so" \
           "$JAVA_HOME/jre/lib/amd64/"libjavafx*.so \
           "$JAVA_HOME/jre/lib/amd64/"libjfx*.so \
    && rm -rf "$JAVA_HOME/jre/bin/jjs" \
           "$JAVA_HOME/jre/bin/keytool" \
           "$JAVA_HOME/jre/bin/orbd" \
           "$JAVA_HOME/jre/bin/pack200" \
           "$JAVA_HOME/jre/bin/policytool" \
           "$JAVA_HOME/jre/bin/rmid" \
           "$JAVA_HOME/jre/bin/rmiregistry" \
           "$JAVA_HOME/jre/bin/servertool" \
           "$JAVA_HOME/jre/bin/tnameserv" \
           "$JAVA_HOME/jre/bin/unpack200" \
           "$JAVA_HOME/jre/lib/ext/nashorn.jar" \
           "$JAVA_HOME/jre/lib/jfr.jar" \
           "$JAVA_HOME/jre/lib/jfr" \
           "$JAVA_HOME/jre/lib/oblique-fonts"
USER tibco
WORKDIR ${USER_HOME}
# EOF
