#!/bin/bash
export MYIP=`ip -f inet addr show eth0 | grep -Po 'inet \K[\d.]+'`
/arachni/bin/arachni_rpcd --address=$MYIP $@ 
