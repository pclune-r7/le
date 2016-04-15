#!/usr/bin/env bash

. vars

#############                                                      ##############
#       "multilog workflow"                                                     #
#       test scenarios: behaviour of agent with the --multilog parameter        #
#                                                                               #
#############                                                      ##############


HOST_MUTLIPLE_KEY=9df0ea6f-36fa-820f-a6bc-c97da8939a06

# Reference: LOG-7549
Scenario 'Agent follows files using --multilog parameter'

Testcase 'Init'

#$LE init --account-key=$ACCOUNT_KEY --host-key=$HOST_KEY --hostname myhost
##e Initialized

$LE init --account-key=$ACCOUNT_KEY --host-key=$HOST_MUTLIPLE_KEY
#e Initialized

Testcase 'Use --multilog parameter with pathname with no wildcard'

mkdir apache-01
touch apache-01/current

$LE follow "$TMP/apache-01/current" --multilog
#e Configuration files loaded: sandbox_config
#e Connecting to 127.0.0.1:8081
#e Domain request: GET /f720fe54-879a-11e4-81ac-277d856f873e/hosts/9df0ea6f-36fa-820f-a6bc-c97da8939a06/ None {}
#e List response: {"object": "loglist", "list": [{"name": "current", "key": "484d6e95-a4e1-42fe-820f-5a4c0824428c", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "$TMP/apache-01/current"}, {"name": "Apache", "key": "fa32313c-3907-4214-ac41-3ff9c6549a22", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "$TMP/apache*/current"}], "response": "ok"}

#o
#oFiles found already being followed, Total 1:
#oLOGNAME 	 FILENAME
#ocurrent 	 $TMP/apache-01/current
#o
#oAll files found are already being followed
#o

# tidy up test directory's
rm -rf apache*

#Testcase 'Use --multilog parameter with wildcard in a directory name in pathname'
#todo this testcase needs review - not sure if it needs fixing!!

#mkdir apache-01
#touch apache-01/current
#mkdir apache-02
#touch apache-02/current
#mkdir apache-03
#touch apache-03/current

#$LE follow "$TMP/apache*/current" --multilog
##e Configuration files loaded: sandbox_config
##e Connecting to 127.0.0.1:8081
##e Domain request: GET /f720fe54-879a-11e4-81ac-277d856f873e/hosts/9df0ea6f-36fa-820f-a6bc-c97da8939a06/ None {}
##e List response: {"object": "loglist", "list": [{"name": "current", "key": "484d6e95-a4e1-42fe-820f-5a4c0824428c", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "$TMP/apache-01/current"}, {"name": "Apache", "key": "fa32313c-3907-4214-ac41-3ff9c6549a22", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "$TMP/apache*/current"}], "response": "ok"}
##o
##oFiles found already being followed, Total 1:
##o	 LOGNAME 	 FILENAME
##o	 Log name 2 	 $TMP/apache-01/current
##o	 Log name 2 	 $TMP/apache-02/current
##o	 Log name 2 	 $TMP/apache-03/current
##o
##oAll files found are already being followed
##o


# Reference: LOG-7549
Scenario 'Agent follows multiple files across a number of directorys, writing to the one log'

Testcase 'Init'

$LE init --account-key=$ACCOUNT_KEY --host-key=$HOST_MUTLIPLE_KEY
#e Initialized


Testcase 'Verify that new events written to multiple files are sent by agent'
# todo need a similar testcase that shows events being sent to the same log - using token?

mkdir apache-01
touch apache-01/current
mkdir apache-02
touch apache-02/current
mkdir apache-03
touch apache-03/current

$LE --debug-transport-events monitor &
#e Configuration files loaded: sandbox_config
#e V1 metrics disabled
#e Connecting to 127.0.0.1:8081
#e Domain request: GET /f720fe54-879a-11e4-81ac-277d856f873e/hosts/9df0ea6f-36fa-820f-a6bc-c97da8939a06/ None {}
#e List response: {"object": "loglist", "list": [{"name": "current", "key": "484d6e95-a4e1-42fe-820f-5a4c0824428c", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "$TMP/apache-01/current"}, {"name": "Apache", "key": "fa32313c-3907-4214-ac41-3ff9c6549a22", "created": 1418711930412, "retention": -1, "follow": "true", "object": "log", "type": "agent", "filename": "$TMP/apache*/current"}], "response": "ok"}
#e Following $TMP/apache-01/current
#e Opening connection 127.0.0.1:8081 PUT /f720fe54-879a-11e4-81ac-277d856f873e/hosts/9df0ea6f-36fa-820f-a6bc-c97da8939a06/484d6e95-a4e1-42fe-820f-5a4c0824428c/?realtime=1 HTTP/1.0
#e Following $TMP/apache*/current
#e Opening connection 127.0.0.1:8081 PUT /f720fe54-879a-11e4-81ac-277d856f873e/hosts/9df0ea6f-36fa-820f-a6bc-c97da8939a06/fa32313c-3907-4214-ac41-3ff9c6549a22/?realtime=1 HTTP/1.0

LE_PID=$!

sleep 1
echo 'First message' >> apache-01/current
echo 'Second message' >> apache-02/current
echo 'Third message' >> apache-03/current
sleep 1

#e First message
#e Second message
#e Third message

# tidy up test directory and daemon
rm -rf apache*
kill $LE_PID


#Testcase 'Use the --name= option to specify log name when setting up files to follow'
#$LE follow "$TMP/apache-*/current" --multilog --name=Apache
# todo want to test the use of --name


# Reference: LOG-7549
Scenario 'Verification of pathname rules with use of the --multilog parameter'

Testcase 'Init'

$LE init --account-key=$ACCOUNT_KEY --host-key=$HOST_MUTLIPLE_KEY
#e Initialized

Testcase 'Error message displayed when follow command used with more then one wildcard in pathname'

$LE follow '$TMP/apache-*/*/current' --multilog
#e
#eError: Only one wildcard * allowed
#e
#eUsage:
#e   Agent is expecting a path name for a file, which should be between single quotes:
#e         example: '/var/log/directoryname/file.log'
#e   A * wildcard for expansion of directory name can be used. Only the one * wildcard is allowed.
#e   Wildcard can not be used for expansion of filename, but for directory name only.
#e   Place path name with wildcard between single quotes:
#e         example: "/var/log/directory*/file.log"
#e


Testcase 'Error message displayed when follow command used with wildcard for filename'

$LE follow '$TMP/apache-01/*' --multilog
#e
#eError: No wildcard * allowed in filename
#e
#eUsage:
#e   Agent is expecting a path name for a file, which should be between single quotes:
#e         example: '/var/log/directoryname/file.log'
#e   A * wildcard for expansion of directory name can be used. Only the one * wildcard is allowed.
#e   Wildcard can not be used for expansion of filename, but for directory name only.
#e   Place path name with wildcard between single quotes:
#e         example: "/var/log/directory*/file.log"
#e


Testcase 'Error message displayed when follow command used with wildcard in partial filename'

$LE follow '$TMP/apache-01/curr*' --multilog
#e
#eError: No wildcard * allowed in filename
#e
#eUsage:
#e   Agent is expecting a path name for a file, which should be between single quotes:
#e         example: '/var/log/directoryname/file.log'
#e   A * wildcard for expansion of directory name can be used. Only the one * wildcard is allowed.
#e   Wildcard can not be used for expansion of filename, but for directory name only.
#e   Place path name with wildcard between single quotes:
#e         example: "/var/log/directory*/file.log"
#e


Testcase 'Error message displayed when follow command used with wildcard in partial filename, without single quotes'

$LE follow $TMP/apache-01/curr* --multilog
#e
#eError: No wildcard * allowed in filename
#e
#eUsage:
#e   Agent is expecting a path name for a file, which should be between single quotes:
#e         example: '/var/log/directoryname/file.log'
#e   A * wildcard for expansion of directory name can be used. Only the one * wildcard is allowed.
#e   Wildcard can not be used for expansion of filename, but for directory name only.
#e   Place path name with wildcard between single quotes:
#e         example: "/var/log/directory*/file.log"
#e


Testcase 'Error message displayed when follow command used with wildcard expanded by shell'
# Example of where shell expansion of wildcard occurs because sigle quotes were not used,
# resulting in multiple pathnames being used as arguments to agent

mkdir apache-01
touch apache-01/current
mkdir apache-02
touch apache-02/current
mkdir apache-03
touch apache-03/current

$LE follow $TMP/*/current --multilog
#e
#eError: Too many arguments being passed to agent
#e
#eUsage:
#e   Agent is expecting a path name for a file, which should be between single quotes:
#e         example: '/var/log/directoryname/file.log'
#e   A * wildcard for expansion of directory name can be used. Only the one * wildcard is allowed.
#e   Wildcard can not be used for expansion of filename, but for directory name only.
#e   Place path name with wildcard between single quotes:
#e         example: "/var/log/directory*/file.log"
#e

# tidy up test directory's
rm -rf apache*


Testcase 'Error message displayed when follow command used with no pathname'

$LE follow  --multilog
#e
#eError: No pathname detected - Specify the path to the file to be followed
#e
#eUsage:
#e   Agent is expecting a path name for a file, which should be between single quotes:
#e         example: '/var/log/directoryname/file.log'
#e   A * wildcard for expansion of directory name can be used. Only the one * wildcard is allowed.
#e   Wildcard can not be used for expansion of filename, but for directory name only.
#e   Place path name with wildcard between single quotes:
#e         example: "/var/log/directory*/file.log"
#e


Testcase 'Error message displayed when follow command used with wildcard but no filename'

$LE follow  '/*/' --multilog
#e
#eError: No filename detected - Specify the filename to be followed
#e
#eUsage:
#e   Agent is expecting a path name for a file, which should be between single quotes:
#e         example: '/var/log/directoryname/file.log'
#e   A * wildcard for expansion of directory name can be used. Only the one * wildcard is allowed.
#e   Wildcard can not be used for expansion of filename, but for directory name only.
#e   Place path name with wildcard between single quotes:
#e         example: "/var/log/directory*/file.log"
#e


Testcase 'Error message displayed when follow command used with empty string'

$LE follow  '' --multilog
#e
#eError: No filename detected - Specify the filename to be followed
#e
#eUsage:
#e   Agent is expecting a path name for a file, which should be between single quotes:
#e         example: '/var/log/directoryname/file.log'
#e   A * wildcard for expansion of directory name can be used. Only the one * wildcard is allowed.
#e   Wildcard can not be used for expansion of filename, but for directory name only.
#e   Place path name with wildcard between single quotes:
#e         example: "/var/log/directory*/file.log"
#e


Testcase 'Warning message displayed when no file found with valid pathname'
# this test case will need to be changed/deleted when 'dynamic' file following behaviour introduced

$LE follow '/apache-01/newlog' --multilog
#eConfiguration files loaded: sandbox_config
#e
#eWarning: No Files found for /apache-01/newlog
#e



