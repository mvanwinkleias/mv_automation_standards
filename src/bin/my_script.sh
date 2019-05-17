#!/bin/bash

MY_SCRIPT_DEBUG="${MY_SCRIPT_DEBUG:-0}"
MY_SCRIPT_VERBOSE="${MY_SCRIPT_VERBOSE:-0}"
MY_SCRIPT_LOG_TO_STDOUT="${MY_SCRIPT_LOG_TO_STDOUT:-0}"

function my_script_debug
{
	if [[ "$MY_SCRIPT_DEBUG" == "1" ]]
	then
		>&2 echo "$@"
	fi
}

function my_script_verbose
{
	if [[ "$MY_SCRIPT_VERBOSE" == "1" ]]
	then
		>&2 echo "$@"
	fi
}

function write_log
{
	logger "$0[$$]: $@"
	if [[ "$MY_SCRIPT_LOG_TO_STDOUT" == "1" ]]
	then
		echo "$@"	
	fi
}

write_log "$0 $@ $LOGNAME $$ $( pwd ) ---STARTING---"

# Put your code here.

my_script_debug "This is a debug message."
my_script_verbose "This is a verbose message."


write_log "$0  ---ENDING---"
