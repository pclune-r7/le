#!/bin/bash

. vars

#############                                                      ##############
#       "multilog workflow"                                                     #
#       Test Scope: behaviour of agent with the --multilog parameter            #            
#       using server side configuration                                         #
#                                                                               #
#############                                                      ##############

# Reference: LOG-7549
Scenario 'Agent follows files using --multilog parameter'

Testcase 'Init'

$LE init --account-key=$ACCOUNT_KEY --host-key=$HOST_MULTILOG_KEY
#e Initialized

Testcase 'Use --multilog parameter with pathname with no wildcard'

$LE follow --debug-multilog "$TMP/apache-01/current" --multilog
#e Configuration files loaded: sandbox_config
#e Connecting to 127.0.0.1:8081
#e Domain request: POST / host_key=9df0ea6f-36fa-820f-a6bc-c97da8939a06&name=current&user_key=f720fe54-879a-11e4-81ac-277d856f873e&request=new_log&filename=Multilog%3A%2Ftmp%2F$SUBDIR%2Fapache-01%2Fcurrent&follow=true&type= {'Content-Type': 'application/x-www-form-urlencoded'}
#e Domain response: "{"log": {"name": "current", "key": "32fa313c-4c70-4214-9bb6-3ff9c6549a22", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "Multilog:$TMP/apache-01/current"}, "worker": "a0", "response": "ok", "log_key": "32fa313c-4c70-4214-9bb6-3ff9c6549a22"}"
#o Will follow Multilog:$TMP/apache-01/current as current
#e Don't forget to restart the daemon
#e   sudo service logentries restart

Testcase 'Use --multilog parameter with wildcard in a directory name in pathname'

$LE follow --debug-multilog "$TMP/apache*/current" --multilog
#e Configuration files loaded: sandbox_config
#e Connecting to 127.0.0.1:8081
#e Domain request: POST / host_key=9df0ea6f-36fa-820f-a6bc-c97da8939a06&name=current&user_key=f720fe54-879a-11e4-81ac-277d856f873e&request=new_log&filename=Multilog%3A%2Ftmp%2F$SUBDIR%2Fapache%2A%2Fcurrent&follow=true&type= {'Content-Type': 'application/x-www-form-urlencoded'}
#e Domain response: "{"log": {"name": "current", "key": "32fa313c-4c70-4214-9bb6-3ff9c6549a22", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "Multilog:$TMP/apache*/current"}, "worker": "a0", "response": "ok", "log_key": "32fa313c-4c70-4214-9bb6-3ff9c6549a22"}"
#o Will follow Multilog:$TMP/apache*/current as current
#e Don't forget to restart the daemon
#e   sudo service logentries restart

Testcase 'Use the --name= option to specify log name when setting up files to follow'

$LE follow --debug-multilog "$TMP/apache-*/current" --multilog --name=ApacheWeb
#e Configuration files loaded: sandbox_config
#e Connecting to 127.0.0.1:8081
#e Domain request: POST / host_key=9df0ea6f-36fa-820f-a6bc-c97da8939a06&name=ApacheWeb&user_key=f720fe54-879a-11e4-81ac-277d856f873e&request=new_log&filename=Multilog%3A%2Ftmp%2F$SUBDIR%2Fapache-%2A%2Fcurrent&follow=true&type= {'Content-Type': 'application/x-www-form-urlencoded'}
#e Domain response: "{"log": {"name": "ApacheWeb", "key": "32fa313c-4c70-4214-9bb6-3ff9c6549a22", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "Multilog:$TMP/apache-*/current"}, "worker": "a0", "response": "ok", "log_key": "32fa313c-4c70-4214-9bb6-3ff9c6549a22"}"
#o Will follow Multilog:$TMP/apache-*/current as ApacheWeb
#e Don't forget to restart the daemon
#e   sudo service logentries restart

# Reference: LOG-7549
Scenario 'Agent follows multiple files with the same filename across a number of directories, writing to the one log'

Testcase 'Init'

$LE init --account-key=$ACCOUNT_KEY --host-key=$HOST_MULTILOG_KEY
#e Initialized

Testcase 'Verify agent follows files of the same filename across multiple directories'

mkdir apache-01
touch apache-01/current
mkdir apache-02
touch apache-02/current
mkdir apache-03
touch apache-03/current

$LE --debug-events monitor &
#e Configuration files loaded: sandbox_config
#e V1 metrics disabled
#e Connecting to 127.0.0.1:8081
#e Domain request: GET /f720fe54-879a-11e4-81ac-277d856f873e/hosts/9df0ea6f-36fa-820f-a6bc-c97da8939a06/ None {}
#e List response: {"object": "loglist", "list": [{"name": "Apache", "key": "484d6e95-a4e1-42fe-820f-5a4c0824428c", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "Multilog:$TMP/apache*/current"}], "response": "ok"}
#e Following $TMP/apache*/current
#e Opening connection 127.0.0.1:8081 PUT /f720fe54-879a-11e4-81ac-277d856f873e/hosts/9df0ea6f-36fa-820f-a6bc-c97da8939a06/484d6e95-a4e1-42fe-820f-5a4c0824428c/?realtime=1 HTTP/1.0
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
