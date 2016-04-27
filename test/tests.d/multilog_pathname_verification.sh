#!/bin/bash

. vars

#############                                                      ##############
#       "multilog pathname verification"                                        #
#       Test Scope: verification of pathname passed to agent,               #
#       with the --multilog parameter                                           #
#                                                                               #
#############                                                      ##############

# Reference: LOG-7549
Scenario 'Verification of pathname rules with use of the --multilog parameter'

Testcase 'Init'

$LE init --account-key=$ACCOUNT_KEY --host-key=$HOST_MULTILOG_KEY
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

