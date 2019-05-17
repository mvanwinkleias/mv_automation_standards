#!/bin/bash

##############################
# useful variables
##############################

MY_SCRIPT_DEBUG="${MY_SCRIPT_DEBUG:-0}"
MY_SCRIPT_VERBOSE="${MY_SCRIPT_VERBOSE:-0}"
MY_SCRIPT_LOG_TO_STDOUT="${MY_SCRIPT_LOG_TO_STDOUT:-0}"

# Current directory of the source file for the script.
MY_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# The path with all symlinks resolved
MY_SCRIPT_REALPATH="$( realpath "${MY_SCRIPT_DIR}")"
# Just the filename of the script:
MY_SCRIPT_FILE_NAME="$(basename -- "$0")"
# The filename without the extension:
MY_SCRIPT_NAME="${MY_SCRIPT_FILE_NAME%.*}"

##############################
# useful routines
##############################

function get_directory
{
	local name="$1"
	echo "${MY_SCRIPT_REALPATH}/../${name}"
	
}

function get_output_file_name
{
	remainder="$1"

	if [[ ! -n "$remainder" ]]; then
		remainder='generic.txt'
	fi

	local output_file_date="$( date "+%Y-%m-%d-%H-%M-%S" )"
	
	local output_dir = "$(get_directory output)"
	# mkdir -p "$output_dir"
	
	local file_name="${output_dir}/${output_file_date}--${MY_SCRIPT_NAME}--${remainder}"
	
	echo "$file_name"

}

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

####################################
# example code
####################################

my_script_debug "This is a debug message."
my_script_verbose "This is a verbose message."

write_log "Log directory: " $( get_directory log )
write_log "Output directory: " $( get_directory output )
write_log "Input directory: " $( get_directory input )

output_file_name="$( get_output_file_name "sample.txt" )"

write_log "Here is an example output file name: $output_file_name"
###################################
# Put your code here.
###################################

# We'll want to log this AND exit with it.
# If something goes wrong, set it to non-zero
exit_value=0


write_log "$0  ---ENDING--- exit_value:$exit_value"

exit $exit_value
