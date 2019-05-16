#!/bin/bash

MY_SCRIPT_DEBUG="${MY_SCRIPT_DEBUG:-0}"
MY_SCRIPT_VERBOSE="${MY_SCRIPT_VERBOSE:-0}"

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
	logger "$0[$$]: "
}

write_log "$0 $@ $LOGNAME $$ $( pwd ) ---STARTING---"

my_script_debug "This is a debug message."
my_script_verbose "This is a verbose message."

# Put your code here.

write_log "$0  ---ENDING---"
