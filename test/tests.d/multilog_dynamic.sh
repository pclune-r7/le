#!/bin/bash

. vars

#############                                                      ##############
#       "multilog dynamic"                                                      #
#       Test Scope: 'dynamic' behaviour for '--multilog' wildcard.              #  
#       The Agent is initialised and then the command line used to set the      #
#       agent to follow a filepath with a wildcard. The 'dynamic' behaviour     #
#       of the agent for '--multilog' option is then tested.                    #
#       Refer to the agent README for details on this 'dynamic' behaviour.      #    
#                                                                               #
#############                                                      ##############

Scenario 'Using client side configuration to test dynamic behaviour'

Testcase 'init and set client configuration with wildcard for dynamic behaviour'

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

Testcase 'Follow file across existing directories; new ones created; stop following when directories deleted'

mkdir apache-01
touch apache-01/current
mkdir apache-02
touch apache-02/current
mkdir apache-03
touch apache-03/current

$LE --debug-events --debug-multilog monitor &
#e Configuration files loaded: sandbox_config
#e V1 metrics disabled
#e Following $TMP/apache*/current
#e Opening connection 127.0.0.1:10000 
#e Number of followers increased to: 1 
#e Number of followers increased to: 2 
#e Number of followers increased to: 3 
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
mkdir apache-04
touch apache-04/current
#e Number of followers increased to: 4 
sleep 1
echo 'Fourth message' >> apache-01/current
sleep 1
#e Fourth message
rm -rf apache-01
sleep 1
#e Number of followers decreased to: 3 

# tidy up test directory and daemon
rm -rf apache*
kill $LE_PID
wait $LE_PID 2>/dev/null || true


Scenario 'Using server side configuration to test dynamic behaviour'

Testcase 'Init'
$LE init --account-key=$ACCOUNT_KEY --host-key=$HOST_MULTILOG_KEY
#e Initialized

Testcase 'Follow file across directories as new ones created; stop following when directories deleted'

$LE --debug-events --debug-multilog monitor &
#e Configuration files loaded: sandbox_config
#e V1 metrics disabled
#e Connecting to 127.0.0.1:8081
#e Domain request: GET /f720fe54-879a-11e4-81ac-277d856f873e/hosts/9df0ea6f-36fa-820f-a6bc-c97da8939a06/ None {}
#e List response: {"object": "loglist", "list": [{"name": "Apache", "key": "484d6e95-a4e1-42fe-820f-5a4c0824428c", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "Multilog:$TMP/apache*/current"}], "response": "ok"}
#e Following $TMP/apache*/current
#e Opening connection 127.0.0.1:8081 PUT /f720fe54-879a-11e4-81ac-277d856f873e/hosts/9df0ea6f-36fa-820f-a6bc-c97da8939a06/484d6e95-a4e1-42fe-820f-5a4c0824428c/?realtime=1 HTTP/1.0

LE_PID=$!
mkdir apache-01
touch apache-01/current
mkdir apache-02
touch apache-02/current
mkdir apache-03
touch apache-03/current

#e Number of followers increased to: 1 
#e Number of followers increased to: 2 
#e Number of followers increased to: 3 
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
rm -rf apache-01
sleep 1
#e Number of followers decreased to: 2 
echo 'Fourth message' >> apache-02/current
sleep 1
#e Fourth message
echo 'Fifth message' >> apache-03/current
sleep 1
#e Fifth message

# tidy up test directory and daemon
rm -rf apache*
kill $LE_PID
