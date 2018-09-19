#!/bin/sh

set -e

do_site2site_configure() {
  if [ -z "$S2S_PORT" ]; then S2S_PORT=2881; fi
  sed -i "s/nifi\.remote\.input\.host=.*/nifi.remote.input.host=${HOSTNAME}/g" /consul-template/template.d/nifi.properties.tmpl
  sed -i "s/nifi\.remote\.input\.socket\.port=.*/nifi.remote.input.socket.port=${S2S_PORT}/g" /consul-template/template.d/nifi.properties.tmpl
  sed -i "s/nifi\.remote\.input\.secure=true/nifi.remote.input.secure=false/g" /consul-template/template.d/nifi.properties.tmpl
}

do_cluster_node_configure() {

  if [ -z "$ZK_CLIENT_PORT" ]; then ZK_CLIENT_PORT=2181; fi
  sed -i "s/clientPort=.*/clientPort=${ZK_CLIENT_PORT}/g" ${NIFI_HOME}/conf/zookeeper.properties

  sed -i "s/nifi\.web\.http\.host=.*/nifi.web.http.host=${HOSTNAME}/g" /consul-template/template.d/nifi.properties.tmpl
  sed -i "s/nifi\.cluster\.protocol\.is\.secure=true/nifi.cluster.protocol.is.secure=false/g" /consul-template/template.d/nifi.properties.tmpl
  sed -i "s/nifi\.cluster\.is\.node=false/nifi.cluster.is.node=true/g" /consul-template/template.d/nifi.properties.tmpl
  sed -i "s/nifi\.cluster\.node\.address=.*/nifi.cluster.node.address=${HOSTNAME}/g" /consul-template/template.d/nifi.properties.tmpl

  if [ -z "$ELECTION_TIME" ]; then ELECTION_TIME="5 mins"; fi
  sed -i "s/nifi\.cluster\.flow\.election\.max\.wait\.time=.*/nifi.cluster.flow.election.max.wait.time=${ELECTION_TIME}/g" /consul-template/template.d/nifi.properties.tmpl
  
  if [ -z "$NODE_PROTOCOL_PORT" ]; then NODE_PROTOCOL_PORT=2882; fi
  sed -i "s/nifi\.cluster\.node\.protocol\.port=.*/nifi.cluster.node.protocol.port=${NODE_PROTOCOL_PORT}/g" /consul-template/template.d/nifi.properties.tmpl

  if [ -z "$ZK_ROOT_NODE" ]; then ZK_ROOT_NODE="nifi"; fi
  sed -i "s/nifi\.zookeeper\.root\.node=.*/nifi.zookeeper.root.node=\/$ZK_ROOT_NODE/g" /consul-template/template.d/nifi.properties.tmpl
 
  if [ ! -z "$ZK_MYID" ]; then
    sed -i "s/nifi\.state\.management\.embedded\.zookeeper\.start=false/nifi.state.management.embedded.zookeeper.start=true/g" /consul-template/template.d/nifi.properties.tmpl
    mkdir -p ${NIFI_HOME}/state/zookeeper
    echo ${ZK_MYID} > ${NIFI_HOME}/state/zookeeper/myid
  fi

  if [ -z "$ZK_MONITOR_PORT" ]; then ZK_MONITOR_PORT=2888; fi
  if [ -z "$ZK_ELECTION_PORT" ]; then ZK_ELECTION_PORT=3888; fi
  sed -i "/^server\./,$ d" ${NIFI_HOME}/conf/zookeeper.properties
}

sed -i "s/nifi\.ui\.banner\.text=.*/nifi.ui.banner.text=${BANNER_TEXT}/g" /consul-template/template.d/nifi.properties.tmpl
do_site2site_configure

if [ ! -z "$IS_CLUSTER_NODE" ]; then do_cluster_node_configure; fi

tail -F ${NIFI_HOME}/logs/nifi-app.log &


NIFI_TEMPLATE=/consul-template/template.d/nifi.properties.tmpl
NIFI_CFG=${NIFI_HOME}/conf/nifi.properties
STATE_TEMPLATE=/consul-template/template.d/state-management.xml.tmpl
STATE_CFG=${NIFI_HOME}/conf/state-management.xml
HAPROXY_HOSTCFG=/haproxy/haproxy.cfg
RESTART_COMMAND="${NIFI_HOME}/bin/nifi.sh restart"

/bin/consul-template -log-level ${CONSUL_LOGLEVEL:-warn} -consul-addr ${CONSUL_CONNECT:-"172.17.0.1:8500"} -template "${NIFI_TEMPLATE}:${NIFI_CFG}:${RESTART_COMMAND}" -template ${STATE_TEMPLATE}:${STATE_CFG}
