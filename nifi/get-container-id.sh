#!/bin/bash
echo $1|awk -F":" '{print $2}' -|awk -F"_" '{print $3}'