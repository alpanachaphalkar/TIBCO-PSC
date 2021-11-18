#!/usr/bin/env bash

# We enforce limits only in AWS, not in Vagrant

IS_VAGRANT=${TIBCO_INTERNAL_VAGRANT:-"false"}
# if IS_VAGRANT is not set then it is AWS environment and auto sizing of JVM is applicable.
if [ "${IS_VAGRANT}" == "false" ]; then

	# Get available memory settings
	read -r limit mem <<< $(cat /sys/fs/cgroup/memory/memory.stat |grep hierarchical_memory_limit)

	#leave 16MB to any other processes; use up the rest for ourselves
	mem_in_mb="$((${mem}/$((1024*1024))-16))"

    echo "$(date "+%H:%M:%S.000") INFO  ### Running in AWS,JVM memory autosizing available,using -Xmx${mem_in_mb}m ###"
else
    # 256 MB seems plenty in Vagrant
    mem_in_mb=512
    echo "$(date "+%H:%M:%S.000") INFO  ### Running in Vagrant,No JVM memory autosizing available, using hardcoded -Xmx${mem_in_mb}m ###"
fi

#
# TIBCO_INTERNAL_HEAP_DUMP_PATH is a folder optionally allocated in the host and mounted by us.
#   We'll dump any heap there.  That way the file is in the host.  In Vagrant we can
#   inspect it manually; in AWS some daemon can upload it to S3.
#
HEAP_DUMP_PATH=${TIBCO_INTERNAL_HEAP_DUMP_PATH:-"/tmp"}/idm_$(date +%s_%N).hprof

#JAVA_OPTS="-Xmx${mem_in_mb}m -XX:ErrorFile=/tmp/java-$$ -XX:HeapDumpPath=${HEAP_DUMP_PATH}" $@
JAVA_OPTS="-Xms64m -Xmx${mem_in_mb}m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m -XX:MaxHeapSize=512m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true -Djboss.as.management.blocking.timeout=3600 -XX:ErrorFile=/tmp/java-$$ -XX:HeapDumpPath=${HEAP_DUMP_PATH}" $@

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
