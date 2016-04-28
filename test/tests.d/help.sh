#!/bin/bash

# FIXME - this test will break on every agent update

. vars

Scenario 'Help'

Testcase 'List help usage'

$LE
#e Logentries agent version 1.4.33
#e usage: le COMMAND [ARGS]
#e 
#e Where command is one of:
#e   init      Write local configuration file
#e   reinit    As init but does not reset undefined parameters
#e   register  Register this host
#e     --name=  name of the host
#e     --hostname=  hostname of the host
#e   whoami    Displays settings for this host
#e   monitor   Monitor this host
#e   follow <filename>  Follow the given log
#e     --name=  name of the log
#e     --type=  type of the log
#e   followed <filename>  Check if the file is followed
#e   clean     Removes configuration file
#e   ls        List internal filesystem and settings: <path>
#e   rm        Remove entity: <path>
#e   pull      Pull log file: <path> <when> <filter> <limit>
#e 
#e Where parameters are:
#e   --help                  show usage help and exit
#e   --version               display version number and exit
#e   --config=               load specified configuration
#e   --config.d=             load configurations from directory
#e   --account-key=          set account key and exit
#e   --host-key=             set local host key and exit, generate key if key is empty
#e   --no-timestamps         no timestamps in agent reportings
#e   --force                 force given operation
#e   --suppress-ssl          do not use SSL with API server
#e   --yes                   always respond yes
#e   --datahub               send logs to the specified data hub address
#e                           the format is address:port with port being optional
#e   --system-stat-token=    set the token for system stats log (beta)
#e   --pull-server-side-config=False do not use server-side config for following files
#e   --multilog              option used with directory wildcard * (restricted behaviour)
#e

