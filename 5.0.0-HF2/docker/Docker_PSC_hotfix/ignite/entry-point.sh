#!/bin/bash

#
# TIBCO_INTERNAL_HEAP_DUMP_PATH is a folder optionally allocated in the host and mounted by us.
#

HEAP_DUMP_PATH=${TIBCO_INTERNAL_HEAP_DUMP_PATH:-"/tmp"}/idm_$(date +%s_%N).hprof

JVM_OPTS="-Xms2g -Xmx2g -XX:NewSize=512m -XX:SurvivorRatio=6 -XX:+AlwaysPreTouch -XX:+UseG1GC -XX:MaxGCPauseMillis=2000 -XX:GCTimeRatio=4 -XX:InitiatingHeapOccupancyPercent=30 -XX:G1HeapRegionSize=8M -XX:ConcGCThreads=1 -XX:G1HeapWastePercent=10 -XX:+UseTLAB -XX:+ScavengeBeforeFullGC -XX:+DisableExplicitGC" $@

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
