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

FROM alpine:3.8

# Maintainer
# ----------
MAINTAINER Arun Singh <arusingh@tibco.com>

ARG USER_HOME=/home/tibco
ARG ANT_CONTRIB_VERSION=1.0b3
ARG ANT_VERSION=1.10.11
#other ENV

ENV ANT_HOME=/etc/ant-${ANT_VERSION} \
    GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc \
    GLIBC_VERSION=2.27-r0 \
    LANG=C.UTF-8 \
    HOME=${USER_HOME}

ENV PATH=${ANT_HOME}/bin:${PATH}
RUN addgroup -S tibco && adduser -S -G tibco tibco

RUN apk -U upgrade && \
    apk add libstdc++ curl ca-certificates bash wget && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    unset GLIBC_REPO \
    && cd /tmp \
    && curl -sS -o apache-ant-${ANT_VERSION}-bin.tar.gz https://downloads.apache.org/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && mkdir ant-${ANT_VERSION} \
    && tar -zxvf apache-ant-${ANT_VERSION}-bin.tar.gz \
    && mv apache-ant-${ANT_VERSION} ${ANT_HOME} \
    && rm apache-ant-${ANT_VERSION}-bin.tar.gz \
    && rm -rf ant-${ANT_VERSION} \
    && rm -rf ${ANT_HOME}/manual \
    && unset ANT_VERSION

RUN cd /tmp \
	&& wget -O ant-contrib-${ANT_CONTRIB_VERSION}-bin.zip https://sourceforge.net/projects/ant-contrib/files/ant-contrib/${ANT_CONTRIB_VERSION}/ant-contrib-${ANT_CONTRIB_VERSION}-bin.zip

RUN unzip -d /tmp /tmp/ant-contrib-${ANT_CONTRIB_VERSION}-bin.zip  \
    && cp /tmp/ant-contrib/ant-contrib-${ANT_CONTRIB_VERSION}.jar ${ANT_HOME}/lib/ant-contrib.jar \
    && rm -rf /tmp/ant-contrib \
    && rm /tmp/ant-contrib-${ANT_CONTRIB_VERSION}-bin.zip \
    && unset ANT_CONTRIB_VERSION \
    && apk --no-cache add netcat-openbsd zip && \
    ln -s /usr/bin/nc /usr/bin/netcat && \
    apk del wget

USER tibco
WORKDIR ${USER_HOME}
# EOF
