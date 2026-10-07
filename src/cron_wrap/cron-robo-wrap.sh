#!/bin/bash

function cron_robo_wrap_usage
{
	cat << EOF
Usage:
  $0 job-tag leak-mode success-mmin command [arg 1...]

where:
	* job-tag - name to use for logging and for tracking successful runs.
	* leak-mode - what outputs to leak err|out|none
	* success-mmin - if the success file hasn't been touched in this many minutes
		display an error

Description:

* Sends all lines of stdout and stderr to logger with a tag
	("job-tag Info:" , "job-tag Error:")
* If leak-mode is out it will output stdout of the process to stdout
* If leak-mode is err it will output stderr of the process to stderr

* Uses success file /var/tmp/job-tag.success to track last successful run.
* If last successful run hasn't been for success-mmin minutes, it prints an error
* Exits with the exit status of the command.

EOF
}

logger_tag="$1" ; shift
leak_mode="$1" ; shift
success_mmin="$1" ; shift
success_file="/var/tmp/${logger_tag}.success"
stdout_tag="$logger_tag Info:"
stderr_tag="$logger_tag Error:"

if [[ -z "$logger_tag" ]]
then
	>&2 printf "Error: First parameter is job tag.\n";
	cron_robo_wrap_usage
	exit 1;
fi

if [[ -z "$leak_mode" ]]
then
	>&2 printf "Error: second parameter is leak_mode\n"
	cron_robo_wrap_usage
	exit 1;
fi

if [[ -z "$success_mmin" ]]
then
	>&2 printf "Error: third parameter is how many minutes to wait until warning of failed runs."
	cron_robo_wrap_usage
	exit 1;
fi

if [[ -z "$1" ]]
then
	>&2 printf "Error: remaining arguments are command to run\n";
	cron_robo_wrap_usage
	exit 1;
fi

command_result=0
command_to_run=( "$@" )

success_file="/var/tmp/${logger_tag}.success"
stdout_tag="$logger_tag Info:"
stderr_tag="$logger_tag Error:"

if [[ "$leak_mode" == "none" ]]
then
	"${command_to_run[@]}" \
		> >(logger --tag "$stdout_tag") \
		2> >(logger --tag "$stderr_tag")
	command_result=$?
elif [[ "$leak_mode" == "err" ]]
then
	"${command_to_run[@]}" \
		2> >(tee >(logger --tag "$stderr_tag" ) >&2 ) \
		1> >(logger --tag "$stdout_tag" )
	command_result=$?
elif [[ "$leak_mode" == "out" ]]
then
	"${command_to_run[@]}" \
		1> >(tee >(logger --tag "$stdout_tag" ) ) \
		2> >(logger --tag "$stderr_tag" )
	command_result=$?
else
	>&2 printf "Error: invalid leak mode: $leak_mode\n"
	exit 1
fi

if [[ "$command_result" == "0" ]]
then
	touch "$success_file"
fi

[ -z "$(find $success_file -mmin -$success_mmin 2>/dev/null)" ]\
&& >&2 printf "ALERT: $logger_tag hasn't run successfully in > $success_mmin minutes.\n"

exit $command_result


