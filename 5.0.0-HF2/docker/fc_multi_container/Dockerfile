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
# (1) TIB_mdm-JBOSS-PGRS_9.1.0_linux_x86_64.zip (download from TIBCO release portal)
# (2) TIB_CIM.9.1.2_JBOSSORA_sp01.tar (download from TIBCO release portal)
# (3) TIB_cim-ac_5.0.0_linux_x86_64.zip (download from TIBCO release portal)
# (4) TIB_CIM.9.1.0_JBOSSORA_hotfix06.tar (download from TIBCO release portal)
# (5) wildfly-10.1.0.Final.zip (download from https://wildfly.org/downloads/)
# (6) jdk-8u*-linux-x64.tar.gz utility for linux (downlod it from any source)
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
#  docker build -t fc:5.0.0 --build-arg MDM_VERSION=9.1.0 --build-arg MDM_MAJOR_VERSION=9.1 --build-arg FC_VERSION=5.0.0 --build-arg FC_MAJOR_VERSION=5.0 --build-arg  MDM_HOTFIX_VERSION=hotfix06  --rm=true .
#
# ---------------

FROM registry.cloud.okteto.net/psc-alpanachaphalkar/tibco-psc-fcbase:okteto

#MAINTAINER Kameshwar Prasad <kprasad@tibco.com>

ARG USER_HOME=/home/postgres
ARG MDM_VERSION=9.1.0
ARG FC_VERSION=5.0.0
ARG FC_MAJOR_VERSION=5.0
ARG MQ_ON_TROPOS=true
ARG MDM_MAJOR_VERSION=9.1
ARG MDM_HOTFIX_VERSION=hotfix06

#RUN mkdir -p /tmp/build

USER root

RUN gdown --id 1kYylkoJB1rK2xY_A62SE0MsSASyBSQbN --output TIB_mdm-JBOSS-PGRS_${MDM_VERSION}_linux_x86_64.zip \
    && gdown --id 1jlU8Dsl5WWLQKob77c0d0zXYKBO7HzmQ --output TIB_CIM.${MDM_VERSION}_JBOSSORA_${MDM_HOTFIX_VERSION}.tar \
    && gdown --id 10wPHLKLujHwP8XMYBgVMlnUgX391PjAU --output wildfly-10.1.0.Final.zip \
    && gdown --id 11a1dmw_-yXrnWHis9hpdSMT1PWwooBLj --output TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip \
    && gdown --id 1_DzhTu8K_4NANc6UoUc4kpsibEgsuUB- --output jdk-8u271-linux-x64.tar.gz \
    && gdown --id 1w3raniGDnmBWMFzWSoAB1TfYWLlmBXld --output TIB_CIM.9.1.2_JBOSSORA_sp01.tar

COPY ["entry-point.sh", "JBModules", "TIB_mdm-JBOSS-PGRS_${MDM_VERSION}_linux_x86_64.zip","TIB_CIM.${MDM_VERSION}_JBOSSORA_${MDM_HOTFIX_VERSION}.tar", "wildfly-10.1.0.Final.zip", "TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip","jdk-8u*-linux-x64.tar.gz","TIB_CIM.9.1.2_JBOSSORA_sp01.tar","/tmp/build/"]

RUN set -ex; mkdir /home/postgres && \
        chmod -R 777 /home/postgres && \
        yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
        yum install -y postgresql96 postgresql-contrib && \
        #apk --no-cache add shadow && \
        usermod -d ${USER_HOME} -s /bin/sh postgres && \
        #apk --no-cache add tzdata libpq libldap libressl2.7-libcrypto libressl2.7-libssl libxml2 musl linux-pam postgresql-contrib postgresql-client rsync && \
        mkdir -p /tmp/build/ && \
        chmod -R 777 /tmp

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
ENV FC_MULTI_DEPLOY true


RUN     set -ex; mkdir -p $HOME/tmp/build && \
        cd $HOME/tmp/build && \
        mkdir -p $HOME/jarutil && \
        tar xvzf /tmp/build/jdk-8u*-linux-x64.tar.gz -C $HOME/tmp/build && \
        mv $HOME/tmp/build/jdk1.8.0*/* $HOME/jarutil && \
        unzip /tmp/build/TIB_mdm-JBOSS-PGRS_${MDM_VERSION}_linux_x86_64.zip -d $HOME/tmp/build
		
RUN     sed -i 's/<entry key="installationRoot">\/opt\/TIBCO<\/entry>/<entry key="installationRoot">\/home\/postgres\/tibco<\/entry>/' $HOME/tmp/build/TIBCOUniversalInstaller_cim_${MDM_VERSION}.silent && \
        sed -i 's/<entry key="mdm.jboss.zipfile">\/opt\/tibco\/thirdpartyDownload\/wildfly-10.1.0.Final.zip<\/entry>/<entry key="mdm.jboss.zipfile">\/tmp\/build\/wildfly-10.1.0.Final.zip<\/entry>/' $HOME/tmp/build/TIBCOUniversalInstaller_cim_${MDM_VERSION}.silent && \
        sed -i 's/<entry key="LGPLAssemblyDownload">false<\/entry>/<entry key="LGPLAssemblyDownload">true<\/entry>/' $HOME/tmp/build/TIBCOUniversalInstaller_cim_${MDM_VERSION}.silent && \
        sed -i 's/<entry key="LGPLAssemblyPath">\/opt\/tibco\/thirdpartyDownload<\/entry>/<entry key="LGPLAssemblyPath">\/home\/postgres\/tmp\/build<\/entry>/' $HOME/tmp/build/TIBCOUniversalInstaller_cim_${MDM_VERSION}.silent && \
        sed -i 's/<entry key="mdm.create.enterprise">true<\/entry>/<entry key="mdm.create.enterprise">false<\/entry>/' $HOME/tmp/build/TIBCOUniversalInstaller_cim_${MDM_VERSION}.silent && \
        sed -i 's/<entry key="mdm.import.data">true<\/entry>/<entry key="mdm.import.data">false<\/entry>/' $HOME/tmp/build/TIBCOUniversalInstaller_cim_${MDM_VERSION}.silent && \
        sed -i '/<entry key="mdm.enterprise.name">enterprise_name<\/entry>/d' $HOME/tmp/build/TIBCOUniversalInstaller_cim_${MDM_VERSION}.silent && \
        sed -i '/<entry key="mdm.admin.user.name">user_name<\/entry>/d' $HOME/tmp/build/TIBCOUniversalInstaller_cim_${MDM_VERSION}.silent && \
        sed -i '/<entry key="mdm.admin.password">password<\/entry>/d' $HOME/tmp/build/TIBCOUniversalInstaller_cim_${MDM_VERSION}.silent && \
        sed -i '/<entry key="mdm.template.type">template_name<\/entry>/d' $HOME/tmp/build/TIBCOUniversalInstaller_cim_${MDM_VERSION}.silent && \
        sed -i 's/${mdm.server.http.port}/6080/' $HOME/tmp/build/product_cim-jboss-pgrs_${MDM_VERSION}_FeatureConfig.xml && \
        sed -i 's/${mdm.server.stop.port}/6009/' $HOME/tmp/build/product_cim-jboss-pgrs_${MDM_VERSION}_FeatureConfig.xml
RUN     $HOME/tmp/build/TIBCOUniversalInstaller-lnx-x86-64.bin -silent

RUN     set -ex; rm -rf $HOME/tmp/build/* &&\
        mkdir -p ${MQ_HOME}/customEAR &&\
        tar -xvf /tmp/build/TIB_CIM.${MDM_VERSION}_JBOSSORA_${MDM_HOTFIX_VERSION}.tar -C ${MQ_HOME}/customEAR && \
        cd ${MQ_HOME}/customEAR && \
        echo './customUtil.sh -updateEarFile <<! '  >>applyHotFixInDocker.sh && \
        echo 'Y '  >>applyHotFixInDocker.sh && \
        echo 'TIB_CIM.${MDM_VERSION}_${MDM_HOTFIX_VERSION}.jar' >>applyHotFixInDocker.sh && \
        echo '!'  >>applyHotFixInDocker.sh && \
        echo './customUtil.sh -updateConfigWarFile <<! '  >>applyHotFixInDocker.sh && \
        echo 'Y '  >>applyHotFixInDocker.sh && \
        echo 'TIB_CIM.${MDM_VERSION}_${MDM_HOTFIX_VERSION}.jar' >>applyHotFixInDocker.sh && \
        echo '!'  >>applyHotFixInDocker.sh && \
        chmod -R 0700 ${MQ_HOME}/customEAR && \
        ./applyHotFixInDocker.sh && \
        cp config.war $MQ_HOME/configurator/tomcat/webapps && \
        sed -i 's/ <Connector port=\"\${mdm.server.http.port}\" maxHttpHeaderSize=\"8192\" maxPostSize=\"0\"/ <Connector port=\"\${mdm.server.http.port}\" maxHttpHeaderSize=\"8192\"/' ${MQ_HOME}/configurator/tomcat/conf/server.xml && \
        cp ECM.ear $MQ_HOME && \
        cp version.properties $MQ_HOME && \
        cp -R $MQ_HOME/customEAR/schema/DataService/2.0 $MQ_HOME/schema/DataService/2.0 && \
        rm -rf ${MQ_HOME}/customEAR/* && \
        tar -xvf /tmp/build/TIB_CIM.9.1.2_JBOSSORA_sp01.tar -C ${MQ_HOME}/customEAR &&\
        cd ${MQ_HOME}/customEAR && \
        cp ${MQ_HOME}/customEAR/package/version.properties $MQ_HOME && \
        echo 'export JAVA_HOME=$JDK_HOME ' >> applySPInDocker.sh && \
        echo './installSP.sh <<! '  >>applySPInDocker.sh && \
        echo 'Y '  >>applySPInDocker.sh && \
        echo '!'  >>applySPInDocker.sh && \
        chmod -R 0700 ${MQ_HOME}/customEAR && \
        ./applySPInDocker.sh && \
        cp ${MQ_HOME}/customEAR/ECM.ear $MQ_HOME && \
        cd $HOME/tmp/build && \
        rm -rf $HOME/tmp/build/* && \
        unzip /tmp/build/TIB_cim-ac_${FC_VERSION}_linux_x86_64.zip -d $HOME/tmp/build && \
        sed -i 's/<entry key="installationRoot">COMPONENTIZED_TIBCO_HOME<\/entry>/<entry key="installationRoot">\/home\/postgres\/tibco<\/entry>/' TIBCOUniversalInstaller.silent && \
        sed -i 's/<entry key="environmentName">TIBCO-HOME<\/entry>/<entry key="environmentName">\/home\/postgres\/tibco<\/entry>/' TIBCOUniversalInstaller.silent && \
        sed -i 's/<entry key="cimHome">CIM_HOME<\/entry>/<entry key="cimHome">\/home\/postgres\/tibco\/mdm\/${MDM_MAJOR_VERSION}<\/entry>/' TIBCOUniversalInstaller.silent
        
RUN     set -ex; $HOME/tmp/build/TIBCOUniversalInstaller-lnx-x86-64.bin -is:javahome ${JAVA_HOME} -silent && \
        cp -R $AC_HOME/deploy/wildfly/bin/StartMDMServer.sh /home/postgres/tibco/mdm/9.1/bin/wildfly-10.1.0.Final/bin 

# CUSTOM FILES
ADD --chown=postgres:postgres snippet ${MQ_HOME}/bin/wildfly-10.1.0.Final/bin/snippet
ADD --chown=postgres:postgres dynamic_config ${MQ_HOME}/bin/wildfly-10.1.0.Final/bin/dynamic_config
ADD --chown=postgres:postgres config_template ${MQ_HOME}/config_template

# CUSTOM CHANGES TO StartMDMServer.sh script to add placeholders replacement logic
RUN     set -ex; head -n 1 ${JBOSS_HOME}/bin/StartMDMServer.sh > ${JBOSS_HOME}/bin/StartMDMServer_temp.sh && \
        cat ${JBOSS_HOME}/bin/snippet >> ${JBOSS_HOME}/bin/StartMDMServer_temp.sh && \
        tail -n +2 ${JBOSS_HOME}/bin/StartMDMServer.sh >> ${JBOSS_HOME}/bin/StartMDMServer_temp.sh && \
        mv ${JBOSS_HOME}/bin/StartMDMServer_temp.sh ${JBOSS_HOME}/bin/StartMDMServer.sh

RUN     set -ex; chmod +rwx -R ${MQ_HOME}/config_template ${JBOSS_HOME}/bin/dynamic_config ${JBOSS_HOME}/bin/snippet ${JBOSS_HOME}/bin/StartMDMServer.sh && \
        sed -i 's/typeValue="Default\/LDAP"/typeValue="jwt"/' ${MQ_HOME}/config/ConfigValues.xml && \
        sed -i 's/value="VELODBDATA"/value=""/' ${MQ_HOME}/config/ConfigValues.xml && \
        sed -i 's/value="VELODBINDX"/value=""/' ${MQ_HOME}/config/ConfigValues.xml && \
        sed -i 's/value="VELODBDF"/value=""/' ${MQ_HOME}/config/ConfigValues.xml && \
        sed -i 's/value="VELODBTEMPINDX"/value=""/' ${MQ_HOME}/config/ConfigValues.xml && \
        sed -i 's/value="VELODBTEMP"/value=""/' ${MQ_HOME}/config/ConfigValues.xml && \
        sed -i 's/jboss.bind.address:127.0.0.1/jboss.bind.address:0.0.0.0/g' ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
	sed -i 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/g' ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
	sed -i 's/jboss.bind.address.unsecure:127.0.0.1/jboss.bind.address.unsecure:0.0.0.0/g' ${JBOSS_HOME}/standalone/configuration/standalone.xml && \
    sed -i 's/doc\/html//' ${MQ_HOME}/config/help/help.EN && \
    cp /tmp/build/entry-point.sh $HOME/tibco/mdm && \
    chmod 777 $MQ_HOME/config/IgniteMember.xml && \
    cp $AC_HOME/docker/dependents/fc_multi_container/IgniteMember.xml ${MQ_HOME}/config && \
    chmod 777 $MQ_HOME/config/CacheConfig.xml && \
    mv ${MQ_HOME}/config/CacheConfig.xml ${MQ_HOME}/config/CacheConfig.xml.backup.org && \
        cp ${MQ_HOME}/config/CacheConfig.large.xml ${MQ_HOME}/config/CacheConfig.xml && \
        cp -R /tmp/build/modules ${MQ_HOME}/bin/wildfly-10.1.0.Final/ && \
        cp -R $AC_HOME/docker/dependents/fc_multi_container/JBModules/modules ${MQ_HOME}/bin/wildfly-10.1.0.Final/ && \
    unzip ${MQ_HOME}/configurator/tomcat/webapps/config.war -d ${MQ_HOME}/configurator/tomcat/webapps/config && \
    mv "${MQ_HOME}/bin/pgsql/driver" "${MQ_HOME}/bin" &&\
    mkdir -p $HOME/logs && \
    chmod -R 766 $HOME/logs && \
        chmod -R 766 ${MQ_HOME}/common && \
        chmod -R 766 ${MQ_HOME}/config && \
    #rm -rf ${MQ_HOME}/configurator/tomcat/webapps/config.war && \
    rm -rf $HOME/tmp && \
    rm -rf ${MQ_HOME}/bin/wildfly-10.1.0.Final/standalone/tmp && \
    rm -rf ${MQ_HOME}/bin/wildfly-10.1.0.Final/standalone/vfs && \
    rm -rf ${MQ_HOME}/bin/wildfly-10.1.0.Final/standalone/log/*.* && \
    rm -rf ${MQ_HOME}/log/*.* && \
    rm -rf ${MQ_HOME}/bin/buildTool && \
    rm -rf ${MQ_HOME}/bin/*.bat && \
    #rm -rf ${MQ_HOME}/ECM.ear && \
    #rm -rf ${MQ_HOME}/config.war && \
    rm -rf ${MQ_HOME}/test && \
    rm -rf $HOME/tibco/as && \
    rm -rf $HOME/tibco/_installInfo && \
    rm -rf $HOME/tibco/release_notes && \
    rm -rf $HOME/tibco/tools && \
    rm -rf "${MQ_HOME}/bin/pgsql/pgAdmin 4" && \
    rm -rf "${MQ_HOME}/bin/pgsql/doc" && \
    rm -rf "${MQ_HOME}/bin/pgsql/stackbuilder" && \
    rm -rf "${MQ_HOME}/bin/pgsql" &&\
    mkdir -p "${MQ_HOME}/bin/pgsql" &&\
    mv "${MQ_HOME}/bin/driver" "${MQ_HOME}/bin/pgsql" &&\
    rm ${MQ_HOME}/schema/DataService/2.0/AdminService_Action.xsd && \
    rm ${MQ_HOME}/schema/DataService/2.0/cimAdminService.wsdl && \
    rm ${MQ_HOME}/schema/DataService/2.0/cimProcessRecordsService.wsdl && \
    rm ${MQ_HOME}/schema/DataService/2.0/ProcessRecords_Action.xsd && \
    rm -rf ${MQ_HOME}/schema/DataService/2.0/samples/admin && \
    rm -rf ${MQ_HOME}/schema/DataService/2.0/samples/processrecords && \
    zip -r ${MQ_HOME}/common/standard/samples/schemas.zip $HOME/tibco/mdm/${MDM_MAJOR_VERSION}/schema && \
    #mkdir -p ${MQ_HOME}/bin/pgsql/bin/ && \
    #ln -s /usr/bin/psql ${MQ_HOME}/bin/pgsql/bin/psql && \
    rm -rf /tmp/*

WORKDIR $HOME
ENV PATH $TPATH

# Add VOLUMEs to allow backup of MQ_COMMON, MQ_CONFIG , DATABASE
VOLUME ["${MQ_HOME}/bin/pgsql/data", "${MQ_HOME}/bin/pgsql/tablespaces", "${MQ_HOME}/common", "${MQ_HOME}/config"]

EXPOSE 8080 6080 8070 5432 47500 47501 47502 47503 47504 47505 47506 47507 47508 47509 47510 8010 9990 7600 8888

ENTRYPOINT ["/home/postgres/tibco/mdm/entry-point.sh"]

CMD ["/home/postgres/tibco/mdm/9.1/bin/wildfly-10.1.0.Final/bin/StartMDMServer.sh"]
