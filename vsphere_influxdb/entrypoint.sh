#!/bin/bash

while true; do
    /usr/local/bin/vsphere-influxdb-go;
    sleep ${INTERVAL_IN_SECONDS};
done