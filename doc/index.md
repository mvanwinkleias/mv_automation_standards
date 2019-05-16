# Automation Standards

This repository will grow with more information.  It's intended
for people who are looking to either improve their Automation processes
or "get ahead of the game" by starting off in a better posture.

# Program Standards

## Add '--verbose' and '--debug' options to your scripts

```
#!/bin/bash

MY_SCRIPT_DEBUG="${MY_SCRIPT_DEBUG:-0}"

function my_script_debug
{
	if [[ "$MY_SCRIPT_DEBUG" == "1" ]]
	then
		>&2 echo "$@"
	fi
}

my_script_debug "This is a debug message!"

```

## Logging

A good default for logging is syslog.  It gets a lot of (deserved) flack
for not being easily parsed, but it gets the job done.

* See "logger" for bash.
* See Logger::Syslog for Perl.

If you cron something up, you 

## Unix Standards

Good Unix programs:

* Do not output anything to stderr or stdout UNLESS
** they've been told to (i.e. debug, verbose, etc)
** Something went wrong

A good example of why this is good is cron.



## Service User Accounts

Do not cron things as your own user.  Create a service user account.

This prevents things like:

* "Oh, the user that had that important processed cronned left.  His account
was disabled.  That's why it didn't run"

## /etc/cron.d/

Don't use individual user's crontab files to cron up things.  If you're
gonna cron, use /etc/cron.d .
