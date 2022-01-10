#!/usr/bin/env bash

# We enforce limits onl
#
# TIBCO_INTERNAL_HEAP_DUMP_PATH is a folder optionally allocated in the host and mounted by us.
#   We'll dump any heap there.  That way the file is in the host.  In Vagrant we can
#   inspect it manually; in AWS some daemon can upload it to S3.
#
HEAP_DUMP_PATH=${TIBCO_INTERNAL_HEAP_DUMP_PATH:-"/tmp"}/idm_$(date +%s_%N).hprof

#JAVA_OPTS="-Xmx${mem_in_mb}m -XX:ErrorFile=/tmp/java-$$ -XX:HeapDumpPath=${HEAP_DUMP_PATH}" $@
JAVA_OPTS="-Xms1024m -Xmx2048m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m -XX:MaxHeapSize=2048m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true -Djboss.as.management.blocking.timeout=3600 -XX:ErrorFile=/tmp/java-$$ -XX:HeapDumpPath=${HEAP_DUMP_PATH}" $@

ulimit -c unlimited

if [[ -f /tmp/java-$$ ]]; then
    echo "=========Process crashed! Begin content of ErrorFile file======================"
    cat /tmp/java-$$
    echo "=================end of content of ErrorFile file=============================="
fi

if [[ -f ${HEAP_DUMP_PATH} ]]; then
    echo "*-*-*-*-*-*-*-*-*-*-*-*-*-*-Heap dump file created-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
    ls -l ${HEAP_DUMP_PATH}
fi
