#!/bin/bash

. vars

#############                                                      ##############
#       "multilog configuration"                                                #
#       Test Scope: Use of client configuration file with a multilog            # 
#       wildcard pathname for monitoring of files.                              #
#                                                                               #
#############                                                      ##############

Scenario 'Using client side configuration with multilog pathname'

Testcase 'init and set client configuration with wildcard in multilog pathname'

$LE init --account-key=$ACCOUNT_KEY --host-key=$HOST_MULTILOG_KEY
#e Initialized

echo 'pull-server-side-config = False' >>"$CONFIG"
echo '[Apache]' >>"$CONFIG"
echo 'token = 0b52788c-7981-4138-ac40-6720ae2d5f0c' >>"$CONFIG"
echo "path = Multilog:$TMP/apache*/current" >>"$CONFIG"
cat "$CONFIG"
#o [Main]
#o user-key = f720fe54-879a-11e4-81ac-277d856f873e
#o agent-key = 9df0ea6f-36fa-820f-a6bc-c97da8939a06
#o v1_metrics = False
#o metrics-mem = system
#o metrics-token = 
#o metrics-disk = sum
#o metrics-swap = system
#o metrics-space = /
#o metrics-vcpu = 
#o metrics-net = sum
#o metrics-interval = 5s
#o metrics-cpu = system
#o
#o pull-server-side-config = False
#o [Apache]
#o token = 0b52788c-7981-4138-ac40-6720ae2d5f0c
#o path = Multilog:$TMP/apache*/current

Testcase 'Monitoring file in multiple directories'

mkdir apache-01
touch apache-01/current
mkdir apache-02
touch apache-02/current
mkdir apache-03
touch apache-03/current

$LE --debug-events monitor &
#e Configuration files loaded: sandbox_config
#e V1 metrics disabled
#e Following $TMP/apache*/current
#e Opening connection 127.0.0.1:10000 
LE_PID=$!

sleep 1
echo 'First message' >> apache-01/current
sleep 1
#e First message
echo 'Second message' >> apache-02/current
sleep 1
#e Second message
echo 'Third message' >> apache-03/current
#e Third message
sleep 1

# tidy up test directory and daemon
rm -rf apache*
kill $LE_PID

